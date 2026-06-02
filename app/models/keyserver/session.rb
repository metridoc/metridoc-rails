class Keyserver::Session < Keyserver::Base
  # Represents a single Keyserver session record (one row per user session).
  #
  # location identifies the physical space (library branch, computer lab, etc.).
  # Sessions with location = 'Staff' or NULL/blank are excluded from patron
  # analysis — see Keyserver::NonStaffComputer for the classification logic.

  scope :with_location,  -> { where.not(location: [nil, ""]) }
  scope :patron_hours,   -> { where("EXTRACT(HOUR FROM logon) BETWEEN 8 AND 22") }

  # Maps abbreviated header names used in Keyserver's raw CSV export to the
  # column names used in this table.
  def self.superadmin_columns
    ['user_name']
  end

  def self.column_aliases
    {
      'name' => 'computer_name',
      'user' => 'user_name'
    }
  end

  def self.on_conflict_update
    {
      conflict_target: [:computer_name, :user_name, :logon],
      columns: []
    }
  end

  # Excel exports duration in three forms depending on session length:
  #   < 24 h           — Roo returns the raw Excel time fraction (e.g. 0.008206 ≈ 709 s)
  #   >= 24 h with sub-second — Roo returns a DateTime anchored at the Excel epoch
  #                     (Dec 30, 1899), e.g. "1900-01-01T06:36:49+00:00" = 2 d 6:36:49
  #   exact whole days — Roo returns a Date, e.g. "1899-12-31" = exactly 1 day
  # The database stores duration in microseconds (matching the rake import path).
  def self.transform_import_value(column_name, val)
    if column_name == 'duration'
      if val.match?(/\A\d+\.\d+\z/)
        (val.to_f * 86_400 * 1_000_000).round.to_s
      elsif val.match?(/\A\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}/)
        dt = DateTime.parse(val)
        ((dt - DateTime.new(1899, 12, 30)) * 86_400 * 1_000_000).to_i.to_s
      elsif val.match?(/\A\d{4}-\d{2}-\d{2}\z/)
        # Whole-number-of-days duration: Roo returns a Date (no time component)
        # anchored at the same Excel epoch. e.g. "1899-12-31" = 1 day exactly.
        d = Date.parse(val)
        ((d - Date.new(1899, 12, 30)).to_i * 86_400 * 1_000_000).to_s
      else
        val
      end
    else
      val
    end
  end

end

class Keyserver::Session < Keyserver::Base
  # Represents a single Keyserver session record (one row per user session).
  #
  # location identifies the physical space (library branch, computer lab, etc.).
  # Sessions with location = 'Staff' or NULL/blank are excluded from patron
  # analysis — see Keyserver::NonStaffComputer for the classification logic.

  # user_name is the raw identifier as Keyserver recorded it. It is treated as a
  # super-admin-only column: the admin views display it only to super admins
  # (see app/admin/keyserver/session.rb), following the superadmin_columns pattern.
  def self.superadmin_columns = [:user_name]

  # duration is the session length in whole seconds. It is not taken from the
  # source file; instead it is derived from logon/logoff as records are built
  # during import. The import constructs each row with Session.new(attributes),
  # so this runs before the rows are bulk-inserted via activerecord-import.
  after_initialize :derive_duration, if: :new_record?

  scope :with_location,  -> { where.not(location: [nil, ""]) }
  scope :patron_hours,   -> { where("EXTRACT(HOUR FROM logon) BETWEEN 8 AND 22") }

  # Columns the importers must never read from the source file. The rake import
  # drops them via the YAML column_mappings; the File Upload tool, which maps
  # columns by header automatically, honors this list instead. duration is
  # listed here because it is derived from logon/logoff (see derive_duration) —
  # importing the source value would let an Excel-duration cell (Roo reads it as
  # a DateTime for multi-day sessions) or a time-formatted CSV string fail the
  # integer validation and drop the row.
  def self.import_derived_columns
    %w[duration]
  end

  # Re-uploading a file that overlaps existing data is safe: rows matching the
  # natural key are left untouched rather than raising a uniqueness error.
  def self.on_conflict_update
    {
      conflict_target: [:computer_name, :user_name, :logon],
      columns: []
    }
  end

  private

  def derive_duration
    return unless logon.present? && logoff.present?

    self.duration = (logoff.to_time - logon.to_time).round
  end
end

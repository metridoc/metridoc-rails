class Keyserver::Session < Keyserver::Base
  # Represents a single Keyserver session record (one row per user session).
  #
  # location identifies the physical space (library branch, computer lab, etc.).
  # Sessions with location = 'Staff' or NULL/blank are excluded from patron
  # analysis — see Keyserver::NonStaffComputer for the classification logic.

  scope :with_location,  -> { where.not(location: [nil, ""]) }
  scope :patron_hours,   -> { where("EXTRACT(HOUR FROM logon) BETWEEN 8 AND 22") }

  def self.on_conflict_update
    {
      conflict_target: [:computer_name, :user_name, :logon],
      columns: []
    }
  end

end

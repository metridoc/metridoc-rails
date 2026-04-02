class Keyserver::Session < Keyserver::Base
  # Represents a single Keyserver session record (one row per user session).
  #
  # location identifies the physical space (library branch, computer lab, etc.).
  # Sessions with location = 'Staff' or NULL/blank are excluded from patron
  # analysis — see Keyserver::NonStaffComputer for the classification logic.

  belongs_to :user_name_map,
             class_name:  'Keyserver::UserNameMap',
             foreign_key: :user_name,
             primary_key: :original,
             optional:    true

  scope :with_location,  -> { where.not(location: [nil, ""]) }
  scope :patron_hours,   -> { where("EXTRACT(HOUR FROM logon) BETWEEN 8 AND 22") }
end

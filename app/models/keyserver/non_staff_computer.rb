class Keyserver::NonStaffComputer < Keyserver::Base
  # Read-only view: computers classified as non-staff.
  # See db/views/keyserver_non_staff_computers_v01.sql for classification logic.

  self.primary_key = :computer_name

  def readonly?
    true
  end
end

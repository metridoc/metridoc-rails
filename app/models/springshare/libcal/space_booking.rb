class Springshare::Libcal::SpaceBooking < Springshare::Libcal::Base
  self.ignored_columns = [
    :first_name,
    :last_name,
    :email,
    :account,
    :penn_id,
    :pennkey
  ]
end

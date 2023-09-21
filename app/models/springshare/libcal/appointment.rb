class Springshare::Libcal::Appointment < Springshare::Libcal::Base
  self.ignored_columns = [
    :patron_first_name,
    :patron_last_name,
    :patron_email
  ]
end

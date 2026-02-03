class Springshare::Libwizard::Etlm < Springshare::Libwizard::Base
  # Define the SuperAdmin columns
  def self.superadmin_columns
    [
      "patron_name", "patron_email"
    ]
  end
end
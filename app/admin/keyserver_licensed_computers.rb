ActiveAdmin.register Keyserver::LicensedComputer do
  menu false
  permit_params :licensee_id, :licensee_server_id, :licensee_computer_id, :licensee_policy_id, :licensee_acknowledged, :licensee_last_used, :licensee_lease_date, :licensee_lease_expiration
end
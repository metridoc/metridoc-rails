ActiveAdmin.register Keyserver::LicensedUser do
  menu false
  permit_params :licensee_id, :licensee_server_id, :licensee_user_id, :licensee_policy_id, :licensee_acknowledged, :licensee_last_used, :licensee_lease_date, :licensee_lease_expiration
  actions :all, :except => [:edit, :update, :destroy]
end
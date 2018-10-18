ActiveAdmin.register Keyserver::Policy do
  menu false
  permit_params :policy_id, :policy_server_id, :policy_ref_num, :policy_name, :policy_action, :policy_metric, :policy_maximum, :policy_lease_time, :policy_status, :policy_expiration, :policy_options, :policy_folder_id, :policy_contract_id, :policy_cost_center, :policy_message, :policy_notes
end
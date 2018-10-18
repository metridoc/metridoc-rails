ActiveAdmin.register Keyserver::PolicyProduct do
  menu false
  permit_params :polprod_id, :polprod_server_id, :polprod_policy_id, :polprod_product_id, :polprod_position, :polprod_flags
end
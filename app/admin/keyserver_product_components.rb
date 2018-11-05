ActiveAdmin.register Keyserver::ProductComponent do
  menu false
  permit_params :component_id, :component_server_id, :component_product_id, :component_program_variant, :component_utility, :component_position, :component_flags
end
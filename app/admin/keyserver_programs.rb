ActiveAdmin.register Keyserver::Program do
  menu false
  permit_params :program_id, :program_variant, :program_variant_name, :program_variant_version, :program_platform, :program_publisher, :program_status
  actions :all, :except => [:new, :edit, :update, :destroy]

  filter :program_id, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :program_variant, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :program_variant_name, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :program_variant_version, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :program_platform, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :program_publisher, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :program_status, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]

end

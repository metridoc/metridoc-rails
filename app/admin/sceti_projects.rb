ActiveAdmin.register Sceti::Project do
  menu false
  permit_params :name, :active

  config.sort_order = 'name_asc'

  filter :name
  filter :active

  form do |f|
    f.input :name, :input_html => { :maxlength => 200 }
    f.input :active

    f.actions
  end

end

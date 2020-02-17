ActiveAdmin.register Sceti::Project do
  menu false
  permit_params :name, :active

  form do |f|
    f.input :name, :input_html => { :maxlength => 200 }
    f.input :active

    f.actions
  end

end
ActiveAdmin.register GateCount::CardSwipe do
  menu false
  permit_params :entry_date,
    :entry_time,
    :door_name,
    :affiliation_desc,
    :center_desc, 
    :dept_desc,
    :usc_desc

  actions :all, :except => [:new, :edit, :update, :destroy]

  preserve_default_filters!

  filter :door_name_present, :as => :boolean

end

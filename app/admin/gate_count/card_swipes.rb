ActiveAdmin.register GateCount::CardSwipe,
  as: "Card Swipes",
  namespace: :gate_count do
  menu false

  breadcrumb do
    [
      link_to('GateCount', :gate_count_root)
    ]
  end

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

ActiveAdmin.register GateCount::CardSwipe do
  menu false
  permit_params :entry_date, :entry_time, :door_name, :affiliation_desc, :center_desc, :dept_desc, :usc_desc
  actions :all, :except => [:edit, :update, :destroy]
end
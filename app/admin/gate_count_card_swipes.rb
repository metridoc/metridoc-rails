ActiveAdmin.register GateCount::CardSwipe do
  menu false
  permit_params :entry_date, :entry_time, :door_name, :affiliation_desc, :center_desc, :dept_desc, :usc_desc
  actions :all, :except => [:new, :edit, :update, :destroy]

  preserve_default_filters!

  filter :entry_date, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :entry_time, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :door_name, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :affiliation_desc, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :center_desc, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :dept_desc, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :usc_desc, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]

end
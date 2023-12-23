ActiveAdmin.register Keyserver::Usage do
  menu false
  permit_params :usage_id, :usage_event, :usage_user_group, :usage_division, :usage_when, :usage_time, :usage_other_time
  actions :all, :except => [:new, :edit, :update, :destroy]

  filter :usage_id, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :usage_event, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :usage_user_group, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :usage_division, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :usage_when, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :usage_time, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :usage_other_time, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]


end

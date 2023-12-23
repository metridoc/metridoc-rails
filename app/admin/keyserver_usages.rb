ActiveAdmin.register Keyserver::Usage do
  menu false
  permit_params :usage_id,
  :usage_event,
  :usage_user_group,
  :usage_division,
  :usage_when,
  :usage_time,
  :usage_other_time
  actions :all, :except => [:new, :edit, :update, :destroy]
end

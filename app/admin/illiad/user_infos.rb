ActiveAdmin.register Illiad::UserInfo,
as: "UserInfo",
namespace: :illiad do
  menu false
  permit_params :institution_id, :department, :nvtgc, :org, :rank, :status
  actions :all, :except => [:new, :edit, :update, :destroy]

  preserve_default_filters!

  filter :department, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :nvtgc, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :org, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :rank, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :status, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]

end

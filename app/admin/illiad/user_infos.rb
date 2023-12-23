ActiveAdmin.register Illiad::UserInfo,
as: "UserInfo",
namespace: :illiad do
  menu false
  permit_params :institution_id, :department, :nvtgc, :org, :rank, :status
  actions :all, :except => [:new, :edit, :update, :destroy]

  preserve_default_filters!
  remove_filter :group_no
  remove_filter :transaction_number
end

ActiveAdmin.register Illiad::UserInfo do
  menu false
  permit_params :institution_id, :department, :nvtgc, :org, :rank, :status
  actions :all, :except => [:edit, :update, :destroy]
end
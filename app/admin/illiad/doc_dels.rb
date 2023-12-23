ActiveAdmin.register Illiad::DocDel,
as: "DocDel",
namespace: :illiad do
  menu false

  permit_params :institution_id, :request_type, :status, :transaction_date,
  :transaction_number

  actions :all, :except => [:new, :edit, :update, :destroy]

  preserve_default_filters!
  remove_filter :group_no

end

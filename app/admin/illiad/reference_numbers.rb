ActiveAdmin.register Illiad::ReferenceNumber,
as: "ReferenceNumber",
namespace: :illiad do
  menu false

  permit_params :institution_id, :oclc, :ref_number, :ref_type,
  :transaction_number

  actions :all, :except => [:new, :edit, :update, :destroy]

  preserve_default_filters!
  remove_filter :group_no
end

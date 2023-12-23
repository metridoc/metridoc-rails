ActiveAdmin.register Illiad::HistoryRecord,
as: "HistoryRecord",
namespace: :illiad do
  menu false
  permit_params :institution_id, :transaction_number, :record_datetime, :entry
  actions :all, :except => [:new, :edit, :update, :destroy]

  preserve_default_filters!
  remove_filter :group_no
end

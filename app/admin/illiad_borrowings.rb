ActiveAdmin.register Illiad::Borrowing do
  menu false
  permit_params :institution_id, :request_type, :transaction_date, :transaction_number, :transaction_status
end
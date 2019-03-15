ActiveAdmin.register Borrowdirect::MinShipDate do
  menu false
  permit_params :request_number, :min_ship_date
  actions :all, :except => [:new, :edit, :update, :destroy]
end

ActiveAdmin.register Circulation::PickUpRequest do
  menu false
  permit_params :location, :received, :local_processed, :offsite_processed, :abandoned, :date
end
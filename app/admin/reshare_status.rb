ActiveAdmin.register Reshare::Status do
  menu false
  actions :all, :except => [:new, :edit, :update, :destroy]

  permit_params :last_updated,
    :origin,
    :st_id,
    :st_version,
    :st_code
end

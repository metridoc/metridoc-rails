ActiveAdmin.register UpennAlma::Department do
  menu false
  actions :all, :except => [:new, :edit, :update, :destroy]

  permit_params :department_code, :school
end

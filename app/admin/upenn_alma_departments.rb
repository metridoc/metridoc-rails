ActiveAdmin.register UpennAlma::Department do
  menu false
  permit_params :department_code, :school
end

ActiveAdmin.register UpennAlma::Division do
  menu false
  actions :all, :except => [:new, :edit, :update, :destroy]

  permit_params :division, :division_description, :school
end

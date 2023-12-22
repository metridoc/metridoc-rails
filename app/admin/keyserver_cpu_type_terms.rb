ActiveAdmin.register Keyserver::CpuTypeTerm do
  menu false
  permit_params :term_id, :term_value, :term_abbreviation
  actions :all, :except => [:new, :edit, :update, :destroy]
end

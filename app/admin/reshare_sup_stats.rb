ActiveAdmin.register Reshare::SupStat do
  menu false
  permit_params :ss_supplier

  filter :ss_supplier, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]

end

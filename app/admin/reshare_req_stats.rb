ActiveAdmin.register Reshare::ReqStat do
  menu false
  permit_params :rs_requester

  filter :rs_requester, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]

end

ActiveAdmin.register Ipeds::Cipcode, namespace: :ipeds do
  menu false
  actions :all, :except => [:new, :edit, :update, :destroy]
end

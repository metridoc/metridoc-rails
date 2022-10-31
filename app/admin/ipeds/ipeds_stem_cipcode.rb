ActiveAdmin.register Ipeds::StemCipcode, namespace: :ipeds do
  menu false
  actions :all, :except => [:new, :edit, :update, :destroy]
end

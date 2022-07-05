ActiveAdmin.register Ipeds::StemCipcode, namespace: :ipeds do
  menu false
  actions :all, except: [:edit, :destroy]
end

ActiveAdmin.register Ipeds::Cipcode, namespace: :ipeds do
  menu false
  actions :all, except: [:edit, :destroy]
end

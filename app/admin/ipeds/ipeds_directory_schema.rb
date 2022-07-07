ActiveAdmin.register Ipeds::DirectorySchema, namespace: :ipeds do
  menu false
  actions :all, except: [:edit, :destroy]
end

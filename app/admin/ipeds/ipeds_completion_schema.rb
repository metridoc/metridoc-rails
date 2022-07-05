ActiveAdmin.register Ipeds::CompletionSchema, namespace: :ipeds do
  menu false
  actions :all, except: [:edit, :destroy]
end

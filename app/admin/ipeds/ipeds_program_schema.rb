ActiveAdmin.register Ipeds::ProgramSchema, namespace: :ipeds do
  menu false
  actions :all, :except => [:new, :edit, :update, :destroy]
end

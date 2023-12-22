ActiveAdmin.register Alma::Circulation do
  menu false
  actions :all, :except => [:new, :edit, :update, :destroy]
end

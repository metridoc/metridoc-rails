ActiveAdmin.register Ares::ItemUsage do
  menu false
  actions :all, :except => [:new, :edit, :update, :destroy]

  preserve_default_filters!

end

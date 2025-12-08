ActiveAdmin.register Caiasoft::DeaccessionInfo,
  namespace: :caiasoft do
    menu false

    breadcrumb do
      [
        link_to('Caiasoft', :caiasoft_root)
      ]
    end

    actions :all, :except => [:new, :edit, :update, :destroy]

    index title: "Deaccession Info"
  end

ActiveAdmin.register_page "Caiasoft",
  namespace: :caiasoft do

    menu false

    content title: "Caiasoft" do
      render partial: 'index'
    end
  end

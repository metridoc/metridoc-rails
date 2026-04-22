ActiveAdmin.register_page "About", namespace: :keyserver do
  menu false

  content title: "Keyserver" do
    render partial: 'index'
  end
end

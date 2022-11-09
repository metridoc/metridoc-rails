ActiveAdmin.register_page "About", namespace: :rsat do
  menu false

  content title: "RSAT" do
    render partial: 'index'
  end
end

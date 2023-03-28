ActiveAdmin.register_page "About",
namespace: :ezproxy do

  menu false

  content title: "EZProxy" do
    render partial: 'index'
  end
end

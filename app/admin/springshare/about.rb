ActiveAdmin.register_page "About",
namespace: :springshare do

  menu false

  content title: "Springshare" do
    render partial: 'index'
  end
end

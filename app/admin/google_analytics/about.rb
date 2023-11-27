ActiveAdmin.register_page "About",
namespace: :google_analytics do

  menu false

  content title: "Google Analytics" do
    render partial: 'index'
  end
end

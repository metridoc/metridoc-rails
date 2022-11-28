ActiveAdmin.register_page "About",
namespace: :ezborrow do

  menu false

  content title: "EZBorrow" do
    render partial: 'index'
  end
end

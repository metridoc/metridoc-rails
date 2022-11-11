ActiveAdmin.register_page "About",
namespace: :borrowdirect do

  menu false

  content title: "BorrowDirect" do
    render partial: 'index'
  end
end

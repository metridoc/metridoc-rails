ActiveAdmin.register_page "BorrowDirect", namespace: :borrowdirect do

  menu false

  content title: "BorrowDirect" do
    render partial: 'index'
  end
end

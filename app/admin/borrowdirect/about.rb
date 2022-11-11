ActiveAdmin.register_page "BorrowDirect", namespace: :rsat do

  breadcrumb do
    # Custom breadcrumb links
    [
      link_to('RSAT', :rsat_root)
    ]
  end

  menu false

  content title: "RSAT::BorrowDirect" do
    render partial: 'index'
  end
end

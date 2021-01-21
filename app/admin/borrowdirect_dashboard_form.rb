ActiveAdmin.register_page "Borrowdirect Dashboard Form" do

  breadcrumb do
    # Custom breadcrumb links
    [link_to('Admin', admin_root_path), link_to('BorrowDirect', admin_borrowdirect_path)]
  end

  # Do not add to top menu
  menu false

  # Action need to get the redirect with parameters
  page_action :statistics, method: :post do
    redirect_to admin_borrowdirect_dashboard_path(
      fiscal_year: params["fiscal_year"],
      library_id: params["library_id"]
    )
  end

  # General title for the page
  content title: "BorrowDirect Dashboard Form" do

    # This is a sub div to the main_content div?? May not need
    div id: "borrowdirect_dashboard" do
      # Direct path to dashboard template
      render partial: 'admin/borrowdirect/dashboard_form'
    end

  end
end

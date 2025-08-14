ActiveAdmin.register_page "Libwizard",
namespace: :springshare do
  menu false

  breadcrumb do
    # Custom breadcrumb links
    [
      link_to('Springshare', :springshare_root)
    ]
  end

  # Action need to get the redirect with parameters
  page_action :statistics, method: :post do
    redirect_url = '/springshare/libwizard_consultation_statistics?' \
                   "staff_pennkey=#{params['pennkey']}"

    # Optionally add a start and end date to the url.
    redirect_url += "&start_date=#{params['start_date']}" unless params['start_date'].blank?
    redirect_url += "&end_date=#{params['end_date']}" unless params['end_date'].blank?

    redirect_to redirect_url
  end
  
  content title: "Springshare::Libwizard" do
    render partial: 'index'
  end

end

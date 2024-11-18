ActiveAdmin.register_page "InquiryMap Statistics",
namespace: :springshare do
  menu false

  breadcrumb do
    # Custom breadcrumb links
    [
      link_to('Springshare', :springshare_root),
      link_to('InquiryMap', :springshare_inquirymap)
    ]
  end
  
  #Title for the page
  content title: "Statistics" do
    render partial: 'springshare/inquirymap/statistics'
  end
end

ActiveAdmin.register_page "InquiryMap Demographics",
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
  content title: "Demographics" do
    render partial: 'springshare/inquirymap/demographics'
  end

end

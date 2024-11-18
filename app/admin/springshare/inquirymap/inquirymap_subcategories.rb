ActiveAdmin.register_page "InquiryMap Subcategories",
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
  content title: "Subcategories" do
    render partial: 'springshare/inquirymap/subcategories'
  end

end

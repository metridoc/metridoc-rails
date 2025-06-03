ActiveAdmin.register_page "Inquirymap",
namespace: :springshare do
  menu false

  breadcrumb do
    # Custom breadcrumb links
    [
      link_to('Springshare', :springshare_root)
    ]
  end
  
  content title: "Springshare::InquiryMap" do
    render partial: 'index'
  end

end

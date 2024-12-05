ActiveAdmin.register Springshare::Inquirymap::Inquirymap,
as: "Inquirymap::Inquirymap",
namespace: :springshare do
  menu false
  
  breadcrumb do
    # Custom breadcrumb links
    [
      link_to('Springshare', :springshare_root),
      link_to('InquiryMap', :springshare_inquirymap)
    ]
  end

  actions :all, :except => [:new, :edit, :update, :destroy]

  preserve_default_filters!
  remove_filter :chat

  # Set the title on the index page
  index title: "InquiryMap"

end
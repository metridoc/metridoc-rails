ActiveAdmin.register Springshare::Libchat::Inquirymap,
as: "Libchat::InquiryMap",
namespace: :springshare do
  menu false
  
  breadcrumb do
    # Custom breadcrumb links
    [
      link_to('Springshare', :springshare_root),
      link_to('LibChat', :springshare_libchat)
    ]
  end

  actions :all, :except => [:new, :edit, :update, :destroy]

  preserve_default_filters!
  remove_filter :chat

  # Set the title on the index page
  index title: "InquiryMap"

end
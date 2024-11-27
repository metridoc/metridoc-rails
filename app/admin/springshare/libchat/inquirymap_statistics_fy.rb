ActiveAdmin.register_page "InquiryMap Yearly Statistics",
namespace: :springshare do
  menu false

  breadcrumb do
    # Custom breadcrumb links
    [
      link_to('Springshare', :springshare_root),
      link_to('LibChat', :springshare_libchat),
      link_to('InquiryMap Statistics', :springshare_inquirymap_statistics)
    ]
  end

  # General title for the page
  content title: "InquiryMap Yearly Statistics" do
    # Direct path to dashboard template
    render partial: 'springshare/libchat/inquirymap_statistics_fy'
  end
end
ActiveAdmin.register_page "InquiryMap Yearly Statistics",
namespace: :springshare do
  menu false

  breadcrumb do
    # Custom breadcrumb links
    [
      link_to('Springshare', :springshare_root),
      link_to('InquiryMap', :springshare_inquirymap),
      link_to('Longitudinal Statistics', :springshare_inquirymap_statistics)
    ]
  end

  # General title for the page
  content title: "Fiscal Year InquiryMap Statistics" do
    # Direct path to dashboard template
    render partial: 'springshare/inquirymap/statistics_fy'
  end
end
ActiveAdmin.register_page "LibChat Yearly Statistics",
namespace: :springshare do
  menu false

  breadcrumb do
    # Custom breadcrumb links
    [
      link_to('Springshare', :springshare_root),
      link_to('LibChat', :springshare_libchat),
      link_to('Longitudinal Statistics', :springshare_libchat_statistics)
    ]
  end

  # General title for the page
  content title: "Fiscal Year LibChat Statistics" do
    # Direct path to dashboard template
    render partial: 'springshare/libchat/statistics_fy'
  end
end

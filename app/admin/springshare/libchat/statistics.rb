ActiveAdmin.register_page "LibChat Statistics",
namespace: :springshare do
  menu false

  breadcrumb do
    # Custom breadcrumb links
    [
      link_to('Springshare', :springshare_root),
      link_to('LibChat', :springshare_libchat)
    ]
  end

  # General title for the page
  content title: "Longitudinal LibChat Statistics" do
    # Direct path to dashboard template
    render partial: 'springshare/libchat/statistics'
  end
end

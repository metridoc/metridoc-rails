ActiveAdmin.register_page "LibAnswers Statistics",
namespace: :springshare do
  menu false

  breadcrumb do
    # Custom breadcrumb links
    [
      link_to('Springshare', :springshare_root),
      link_to('LibAnswers', :springshare_libanswers)
    ]
  end

  # General title for the page
  content title: "LibAnswers Statistics" do
    # Direct path to dashboard template
    render partial: 'springshare/libanswers/statistics'
  end
end

ActiveAdmin.register_page "Libchats Statistics",
namespace: :springshare do
  menu false

  breadcrumb do
    # Custom breadcrumb links
    [
      link_to('Springshare', :springshare_root),
      link_to('LibAnswers', :springshare_libanswers)
    ]
  end
  
  #Title for the page
  content title: "Libchats Statistics" do
    render partial: 'springshare/libchats/statistics'
  end
end

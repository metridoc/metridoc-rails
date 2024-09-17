ActiveAdmin.register_page "Libchats Sentiment",
namespace: :springshare do
  menu false

  breadcrumb do
    # Custom breadcrumb links
    [
      link_to('Springshare', :springshare_root),
      link_to('Libchats', :springshare_libchats)
    ]
  end
  
  #Title for the page
  content title: "Libchats Sentiment" do
    render partial: 'springshare/libchats/sentiment'
  end

end

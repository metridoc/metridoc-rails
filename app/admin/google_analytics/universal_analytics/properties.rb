ActiveAdmin.register GoogleAnalytics::UniversalAnalytics::Property,
as: "UniversalAnalytics::Property",
namespace: :google_analytics  do

  breadcrumb do
    # Custom breadcrumb links
    [
      link_to('Google Analytics', :google_analytics_root),
      link_to('Universal Analytics', :google_analytics_universal_analytics)
    ]
  end

  menu false
  actions :all, :except => [:new, :create, :edit, :update, :destroy]

  # Set the title on the index page
  index title: "Properties"

end

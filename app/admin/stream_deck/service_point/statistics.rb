ActiveAdmin.register_page "Service Point Statistics",
namespace: :stream_deck do

  breadcrumb do
    [
      link_to('StreamDeck', :stream_deck_root),
      link_to('ServicePoint', :stream_deck_service_point)
    ]
  end

  # Do not add to top menu
  menu false

  # General title for the page
  content title: "Statistics" do
    # Direct path to dashboard template
    render partial: '/stream_deck/service_point/statistics'
  end

end
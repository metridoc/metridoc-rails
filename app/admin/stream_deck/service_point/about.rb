ActiveAdmin.register_page "Service Point",
namespace: :stream_deck do
  menu false

  breadcrumb do
    # Custom breadcrumb links
    [
      link_to('StreamDeck', :stream_deck_root)
    ]
  end

  content title: "StreamDeck::ServicePoint" do
    render partial: 'index'
  end
end
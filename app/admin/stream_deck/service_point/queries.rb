ActiveAdmin.register StreamDeck::ServicePoint::Query,
as: "ServicePoint::Query",
namespace: :stream_deck do
  menu false

  breadcrumb do
    [
      link_to('StreamDeck', :stream_deck_root),
      link_to('ServicePoint', :stream_deck_service_point)
    ]
  end

  actions :all, :except => [:new, :edit, :update, :destroy]

  index title: "Queries"
end
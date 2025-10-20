ActiveAdmin.register StreamDeck::ServicePoint::Entry,
as: "ServicePoint::Entry",
namespace: :stream_deck do
  menu false

  breadcrumb do
    [
      link_to('StreamDeck', :stream_deck_root),
      link_to('ServicePoint', :stream_deck_service_point)
    ]
  end

  actions :all, :except => [:new, :edit, :update, :destroy]

  index title: "Entries"
end
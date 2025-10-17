ActiveAdmin.register_page "About",
namespace: :stream_deck do

  menu false

  content title: "StreamDeck" do
    render partial: 'index'
  end
end
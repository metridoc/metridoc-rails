ActiveAdmin.register Springshare::Libcal::SpaceAnswer,
as: "Libcal::SpaceAnswer",
namespace: :springshare do
  menu false

  breadcrumb do
    # Custom breadcrumb links
    [
      link_to('Springshare', :springshare_root),
      link_to('LibCal', :springshare_libcal)
    ]
  end

  actions :all, :except => [:new, :edit, :update, :destroy]

  # Set the title the index page
  index title: "Space Answer"
end

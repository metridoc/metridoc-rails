ActiveAdmin.register Springshare::Libcal::SpaceLocation,
as: "Libcal::SpaceLocation",
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
  index title: "Location"
end

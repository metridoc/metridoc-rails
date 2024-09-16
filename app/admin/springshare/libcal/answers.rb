ActiveAdmin.register Springshare::Libcal::Answer,
as: "Libcal::Answer",
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

  # Set the title on the index page
  index title: "Answer"
end

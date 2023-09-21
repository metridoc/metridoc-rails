ActiveAdmin.register Springshare::Libcal::Appointment,
as: "Libcal::Appointment",
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
  index title: "Appointment"
end

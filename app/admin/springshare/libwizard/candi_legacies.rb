ActiveAdmin.register Springshare::Libwizard::CandiLegacy,
as: "Libwizard::Consultations::Legacy",
namespace: :springshare do
  menu false

  breadcrumb do
    # Custom breadcrumb links
    [
      link_to('Springshare', :springshare_root),
      link_to('LibWizard', :springshare_libwizard)
    ]
  end

  actions :all, :except => [:new, :edit, :update, :destroy]

  # Set the title on the index page
  index title: "Consulation and Instruction - Legacy"
end
ActiveAdmin.register LibraryStaff::Census,
as: "Census",
namespace: :library_staff do
  menu false

  breadcrumb do
    # Custom breadcrumb links
    [
      link_to('LibraryStaff', :library_staff_root)
    ]
  end

  actions :all, :except => [:new, :edit, :update, :destroy]

  # Set the title on the index page
  index title: "Census"
end

ActiveAdmin.register CourseReserves::Legacy::Item,
as: "Legacy::Item",
namespace: :course_reserves do
  menu false

  breadcrumb do
    # Custom breadcrumb links
    [
      link_to('CourseReserves', :course_reserves_root),
      link_to('Legacy', :course_reserves_legacy)
    ]
  end

  actions :all, :except => [:new, :edit, :update, :destroy]

  # Set the title on the index page
  index title: "Items"
end

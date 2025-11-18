ActiveAdmin.register CourseReserves::Leganto::UsageView,
as: "Leganto::UsageViews",
namespace: :course_reserves do
  menu false

  breadcrumb do
    # Custom breadcrumb links
    [
      link_to('Course Reserves', :course_reserves_root),
      link_to('Leganto', :course_reserves_leganto)
    ]
  end

  actions :all, :except => [:new, :edit, :update, :destroy]

  # Set the title on the index page
  index title: "Usage Extended View"
end
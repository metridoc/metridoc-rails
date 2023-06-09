ActiveAdmin.register CourseReserves::Ares::CustomDropDown,
as: "Ares::CustomDropDown",
namespace: :course_reserves do
  menu false

  breadcrumb do
    # Custom breadcrumb links
    [
      link_to('CourseReserves', :course_reserves_root),
      link_to('Ares', :course_reserves_ares)
    ]
  end

  actions :all, :except => [:new, :edit, :update, :destroy]

  # Set the title on the index page
  index title: "Custom Drop Downs"
end

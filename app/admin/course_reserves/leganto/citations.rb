ActiveAdmin.register CourseReserves::Leganto::Citation,
as: "Leganto::Citation",
namespace: :course_reserves do
  menu false

  breadcrumb do
    [
      link_to('CourseReserves', :course_reserves_root),
      link_to('Leganto', :course_reserves_leganto)
    ]
  end

  actions :all, :except => [:new, :edit, :update, :destroy]

  index title: "Citations"
end
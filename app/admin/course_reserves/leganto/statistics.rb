ActiveAdmin.register_page "Leganto Statistics",
namespace: :course_reserves do

  # Do not add to top menu
  menu false


  breadcrumb do
    # Custom breadcrumb links
    [
      link_to('CourseReserves', :course_reserves_root)
    ]
  end

  # General title for the page
  content title: "Leganto Statistics" do
    # Direct path to dashboard template
    render partial: 'course_reserves/leganto/statistics'
  end
end

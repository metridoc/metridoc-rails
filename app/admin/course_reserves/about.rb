ActiveAdmin.register_page "About",
namespace: :course_reserves do

  menu false

  content title: "CourseReserves" do
    render partial: 'index'
  end
end

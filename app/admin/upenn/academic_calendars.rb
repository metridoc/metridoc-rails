ActiveAdmin.register Upenn::AcademicCalendar, 
as: "Academic Calendar", namespace: :upenn do
  menu false
  actions :all, :except => [:new, :edit, :update, :destroy]
end

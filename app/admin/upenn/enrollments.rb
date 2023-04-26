ActiveAdmin.register Upenn::Enrollment, as: "Enrollments", namespace: :upenn do
  menu false
  actions :all, :except => [:new, :edit, :update, :destroy]
end

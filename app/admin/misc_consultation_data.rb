ActiveAdmin.register Misc::ConsultationData do
  menu if: proc{ authorized?(:read, Misc::ConsultationData) }, parent: I18n.t("active_admin.misc")

  permit_params :submitted,
                :consultation_or_instruction,
                :staff_pennkey,
                :staff_expertise,
                :event_date,
                :mode_of_consultation,
                :session_type,
                :service_provided,
                :outcome,
                :research_community,
                :total_attendance,
                :location,
                :event_length,
                :prep_time,
                :number_of_interactions,
                :patron_type,
                :undergraduate_student_type,
                :graduate_student_type,
                :school_affiliation,
                :department,
                :faculty_sponsor,
                :course_sponsor,
                :course_name,
                :course_number,
                :patron_question,
                :session_description,
                :notes,
                :ip,
                :refer,
                :browser
  actions :all, :except => [:new, :edit, :update, :destroy]

  preserve_default_filters!

end




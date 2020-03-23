ActiveAdmin.register Consultation::Interaction do
  menu false
  permit_params :submitted, :consultation_or_instruction, :staff_pennkey, :staff_expertise, :event_date, :mode_of_consultation, :session_type, :service_provided, :outcome, :research_community, :total_attendance, :location, :event_length, :prep_time, :number_of_interactions, :patron_type, :undergraduate_student_type, :graduate_student_type, :school_affiliation, :department, :faculty_sponsor, :course_sponsor, :course_name, :course_number, :patron_question, :session_description, :notes, :ip, :refer, :browser
end
class CreateConsultationTables < ActiveRecord::Migration[5.1]
  def change
    create_table :consultation_tables do |t|
      create_table :consultation_interactions do |t|
        t.datetime :submitted
        t.string :consultation_or_instruction
        t.string :staff_pennkey
        t.string :staff_expertise
        t.datetime :event_date
        t.string :mode_of_consultation
        t.string :session_type
        t.string :service_provided
        t.string :outcome
        t.string :research_community
        t.string :total_attendance
        t.string :location
        t.string :event_length
        t.string :prep_time
        t.string :number_of_interactions
        t.string :patron_type
        t.string :undergraduate_student_type
        t.string :graduate_student_type
        t.string :school_affiliation
        t.string :department
        t.string :faculty_sponsor
        t.string :course_sponsor
        t.string :course_name
        t.string :course_number
        t.string :patron_question
        t.text :session_description
        t.text :notes
        t.string :ip
        t.string :refer
        t.string :browser
      end
    end
  end
end

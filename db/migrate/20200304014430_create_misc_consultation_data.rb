class CreateMiscConsultationData < ActiveRecord::Migration[5.1]
  def change
    create_table :misc_consultation_data do |t|
      t.datetime :submitted
      t.string   :consultation_or_instruction
      t.string   :staff_pennkey
      t.string   :staff_expertise
      t.date     :event_date
      t.string   :mode_of_consultation
      t.string   :session_type
      t.string   :service_provided
      t.string   :outcome
      t.string   :research_community
      t.integer  :total_attendance
      t.string   :location
      t.integer  :event_length
      t.integer  :prep_time
      t.integer  :number_of_interactions
      t.string   :patron_type
      t.string   :undergraduate_student_type
      t.string   :graduate_student_type
      t.string   :school_affiliation
      t.string   :department
      t.string   :faculty_sponsor
      t.string   :course_sponsor
      t.string   :course_name
      t.string   :course_number
      t.string   :patron_question
      t.string   :session_description
      t.string   :notes
      t.string   :ip
      t.string   :refer
      t.string   :browser
    end

  end
end

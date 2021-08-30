class UpdateConsultationSchema < ActiveRecord::Migration[5.2]


  def change

    drop_table(:consultation_tables, :force => :cascade, :if_exists => true)
    drop_table(:consultation_interactions, :force => :cascade, :if_exists => true)

    create_table :consultation_interactions do |t|
      t.datetime :submitted
      t.string :consultation_or_instruction
      t.string :staff_pennkey
      t.string :staff_expertise
      t.date :event_date
      t.string :mode_of_consultation
      t.string :session_type
      t.string :service_provided
      t.string :rtg
      t.string :outcome
      t.string :research_community
      t.integer :total_attendance
      t.integer :number_of_registrations
      t.string :location
      t.integer :event_length
      t.integer :prep_time
      t.integer :number_of_interactions
      t.string :patron_type
      t.string :patron_name
      t.string :rtg
      t.integer :graduation_year
      t.string :undergraduate_student_type
      t.string :graduate_student_type
      t.string :mba_type
      t.string :campus
      t.string :school_affiliation
      t.string :department
      t.string :faculty_sponsor
      t.string :course_sponsor
      t.string :course_name
      t.string :course_number
      t.string :referral_method
      t.string :patron_question
      t.text :session_description
      t.text :notes
    end
  end
end

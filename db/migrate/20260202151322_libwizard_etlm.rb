class LibwizardEtlm < ActiveRecord::Migration[7.1]
  def change
    create_table :ss_libwizard_etlms do |t|
      t.string "response_id"
      t.datetime "submitted", precision: nil
      t.string "consultation_or_instruction"
      t.string "strategic_priority"
      t.string "staff_pennkey"
      t.string "additional_staff_pennkey"

      t.date "event_date"
      t.date "requested_event_date"

      t.string "mode_of_consultation"
      t.string "service_provided"

      # Workshop information
      t.string "workshop_title"
      t.string "career_advancement"
      t.string "status"
      t.boolean "workshop_agreement"
      t.string "equipment_type"
      t.string "equipment_used"
      t.string "workshop_budget"
      t.string "workshop_cost"
      t.string "outcome"

      # Workshop attendence
      t.integer "number_of_registrations"
      t.integer "total_attendance"
      t.string "location"
      t.integer "event_length"
      t.integer "prep_time"

      # Event Rating
      t.integer "efficiency"
      t.integer "effectiveness"
      t.integer "communication"
      t.integer "engagement"
      t.integer "support"

      # Patron Information
      t.string "patron_type"
      t.boolean "first_visit"
      t.string "referral"
      t.boolean "is_staff"
      t.string "undergraduate_student_type"
      t.string "graduate_student_type"
      t.string "patron_name"
      t.string "patron_email"
      t.string "school_affiliation"
      t.string "graduation_year"
      t.string "academic_department"
      t.string "faculty_sponsor"
      t.string "course_sponsor"
      t.string "course_name"
      t.string "course_number"
      t.string "patron_question"
      t.text "session_description"
      t.text "notes"
      t.datetime "downloaded_at"
      t.index ["response_id"], unique: true
    end
  end
end

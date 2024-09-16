class AddLibraryStaffCensus < ActiveRecord::Migration[5.2]
  def change
    create_table :library_staff_census do |t|
      t.string :employment_status
      t.datetime :employment_status_date
      t.string :position_id
      t.integer :penn_id
      t.integer :workday_id
      t.datetime :hire_date
      t.datetime :occupant_from_date
      t.string :legal_last_name
      t.string :legal_first_name
      t.numeric :calculated_total_fte
      t.numeric :primary_percent_effort
      t.string :position_employee_type
      t.string :full_part_time
      t.integer :position_school_ctr
      t.integer :job_profile_id
      t.string :job_profile_name
      t.string :primary_business_title
      t.string :exempt_job_flag
      t.string :job_family_id
      t.string :worker_location
      t.integer :manager_penn_id
      t.string :job_family_group_name
      t.string :job_family_name
      t.string :primary_email_address_work
      t.string :supervisory_org_name
      t.integer :position_penn_cost_center
      t.string :position_cost_center_desc
      t.string :org_short_name

      t.index ["position_id"], name: "library_staff_census_position_id"
      t.index ["penn_id"], name: "library_staff_census_penn_id"
      t.index ["workday_id"], name: "library_staff_census_workday_id"
    end
  end
end

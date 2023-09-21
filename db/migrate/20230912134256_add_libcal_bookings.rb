class AddLibcalBookings < ActiveRecord::Migration[6.1]
  def change
    create_table :ss_libcal_users do |t|
      t.integer :staff_id # id
      t.string :first_name
      t.string :last_name
      t.string :email

      t.index ["staff_id"], unique: true, name: "ss_libcal_users_id"
    end

    create_table :ss_libcal_appointments do |t|
      t.integer :appointment_id # id
      t.date :from_date
      t.date :to_date
      t.string :patron_first_name # first_name
      t.string :patron_last_name # last_name
      t.string :patron_email # email
      t.integer :staff_id # user_id, Foreign Key to ss_libcal_users
      t.string :location
      t.integer :location_id
      t.string :group
      t.integer :group_id
      t.integer :category_id
      t.string :directions
      t.boolean :cancelled
      t.json :answers # JSON object
      t.date :downloaded_at

      t.index ["appointment_id"], unique: true, name: "ss_libcal_appointments_id"
      t.index ["staff_id"], name: "ss_libcal_appointments_staff_id"
      t.index ["location"], name: "ss_libcal_appointments_location"
      t.index ["group"], name: "ss_libcal_appointments_group"
      t.index ["from_date"], name: "ss_libcal_appointments_from_date"
      t.index ["downloaded_at"], name: "ss_libcal_appointments_downloaded_at"
    end

    create_table :ss_libcal_questions do |t|
      t.integer :question_id #id
      t.string :label
      t.string :answer_type # type - protected name
      t.boolean :required
      t.json :options # JSON object

      t.index ["question_id"], unique: true, name: "ss_libcal_questions_id"
    end

    create_table :ss_libcal_answers do |t|
      t.integer :staff_id # Foreign Key to ss_libcal_users
      t.integer :appointment_id # Foreign Key to ss_libcal_appointments
      t.text :question_id # Foreign Key to ss_libcal_questions
      t.string :answer

      t.index ["appointment_id", "question_id"],
        unique: true, name: "ss_libcal_answers_id"
    end
  end
end

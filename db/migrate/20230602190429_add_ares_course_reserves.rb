class AddAresCourseReserves < ActiveRecord::Migration[5.2]
  def change
    create_table :cr_ares_course_users do |t|
      t.integer :course_id
      t.string :user_type
      t.string :username

      t.index ["course_id"], name: "cr_ares_course_users_course_id"
      t.index ["user_type"], name: "cr_ares_course_users_user_type"
    end

    create_table :cr_ares_courses do |t|
      t.integer :course_id
      t.string :course_code
      t.string :external_course_id
      t.string :registrar_course_id
      t.string :department
      t.string :semester
      t.datetime :start_date
      t.datetime :stop_date
      t.decimal :course_enrollment
      t.string :name
      t.string :instructor
      t.string :default_pickup_site

      t.index ["course_id"], name: "cr_ares_courses_course_id"
      t.index ["semester"], name: "cr_ares_courses_semester"
    end

    create_table :cr_ares_custom_drop_downs do |t|
      t.string :group_name
      t.string :label_name
      t.string :label_value
    end

    create_table :cr_ares_item_history do |t|
      t.integer :item_id
      t.datetime :date_time
      t.string :entry
      t.string :username

      t.index ["item_id"], name: "cr_ares_item_history_item_id"
      t.index ["username"], name: "cr_ares_item_history_username"
    end

    create_table :cr_ares_item_trackings do |t|
      t.integer :item_id
      t.datetime :tracking_date_time
      t.string :status
      t.string :username

      t.index ["item_id"], name: "cr_ares_item_trackings_item_id"
      t.index ["username"], name: "cr_ares_item_trackings_username"
    end

    create_table :cr_ares_items do |t|
      t.integer :item_id
      t.integer :course_id
      t.string :pickup_location
      t.string :processing_location
      t.string :current_status
      t.datetime :current_status_date
      t.string :item_type
      t.boolean :digital_item
      t.string :location
      t.boolean :ares_document
      t.boolean :copyright_required
      t.boolean :copyright_obtained
      t.datetime :active_date
      t.datetime :inactive_date
      t.string :callnumber
      t.text :reason_for_cancellation
      t.boolean :proxy
      t.string :title
      t.string :author
      t.string :publisher
      t.string :pub_place
      t.string :pub_date
      t.string :edition
      t.string :isxn
      t.string :esp_number # External Service Provider Number
      t.string :doi
      t.string :article_title
      t.string :volume
      t.string :issue
      t.string :journal_year
      t.string :journal_month
      t.string :shelf_location
      t.string :document_type
      t.string :item_format
      t.text :description
      t.string :editor
      t.string :item_barcode
      t.string :needed_by

      t.index ["item_id"], name: "cr_ares_items_item_id"
      t.index ["course_id"], name: "cr_ares_items_course_id"
    end

    create_table :cr_ares_semesters do |t|
      t.string :semester
      t.datetime :start_date
      t.datetime :end_date

      t.index ["semester"], name: "cr_ares_semesters_semester"
    end

    create_table :cr_ares_sites do |t|
      t.string :site_code
      t.string :site_name
      t.string :default_processing_site
      t.boolean :available_for_pickup
      t.boolean :available_for_processing
    end

    create_table :cr_ares_users do |t|
      t.string :username
      t.string :last_name
      t.string :first_name
      t.string :library_id
      t.string :department
      t.string :status
      t.string :e_mail_address
      t.string :user_type
      t.datetime :last_login_date
      t.string :cleared
      t.datetime :expiration_date
      t.boolean :trusted
      t.string :auth_method
      t.boolean :course_email_default
      t.string :external_user_id

      t.index ["username"], name: "cr_ares_users_username"
      t.index ["user_type"], name: "cr_ares_users_user_type"
    end

    create_table :cr_legacy_courses do |t|
      t.integer :course_id
      t.string :course_code
      t.string :registrar_course_id
      t.string :semester
      t.string :department
      t.string :name
      t.string :default_pickup_site
      t.string :instructor_pennkey
      t.integer :instructor_penn_id
      t.string :instructor_department
      t.string :instructor_first_name
      t.string :instructor_last_name

      t.index ["course_id"], name: "cr_legacy_courses_course_id"
      t.index ["semester"], name: "cr_legacy_courses_semester"
    end

    create_table :cr_legacy_items do |t|
      t.string :item_id
      t.integer :course_id
      t.string :processing_location
      t.string :location
      t.string :callnumber
      t.string :title
      t.string :author
      t.string :publisher
      t.string :pub_place
      t.string :edition
      t.string :isxn
      t.string :volume
      t.string :document_type
      t.string :item_format
      t.string :item_barcode

      t.index ["course_id"], name: "cr_legacy_items_course_id"
      t.index ["item_id"], name: "cr_legacy_items_item_id"
    end
  end
end

# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2022_07_20_041810) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgstattuple"
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "admin_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "super_admin", default: false, null: false
    t.integer "user_role_id"
    t.string "first_name"
    t.string "last_name"
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "alma_circulations", force: :cascade do |t|
    t.string "policy_name"
    t.string "barcode"
    t.string "item_id"
    t.string "permanent_call_number"
    t.string "classification_code"
    t.string "lc_group1"
    t.string "lc_group2"
    t.string "lc_group3"
    t.string "lc_group4"
    t.string "lc_group5"
    t.string "dewey_number"
    t.string "dewey_group1"
    t.string "dewey_group2"
    t.string "dewey_group3"
    t.string "mms_id"
    t.string "title"
    t.string "title_normalized"
    t.string "author"
    t.string "bibliographic_material_type"
    t.string "physical_item_material_type"
    t.string "bibliographic_resource_type"
    t.string "isbn"
    t.string "isbn_normalized"
    t.string "issn"
    t.string "issn_normalized"
    t.string "oclc_control_number_019"
    t.string "oclc_control_number_035a"
    t.string "oclc_control_number_035z"
    t.string "oclc_control_number_035az"
    t.string "library_name"
    t.string "location_name"
    t.string "resource_sharing_library"
    t.string "user_group"
    t.string "statistical_category_1"
    t.string "statistical_category_2"
    t.string "statistical_category_3"
    t.string "statistical_category_4"
    t.string "statistical_category_5"
    t.string "loan_year"
    t.string "loan_fiscal_year"
    t.datetime "loan_date"
    t.datetime "due_date"
    t.datetime "original_due_date"
    t.string "first_name"
    t.string "last_name"
    t.string "preferred_email"
    t.string "penn_id_number"
  end

  create_table "ares_item_usages", force: :cascade do |t|
    t.string "semester"
    t.string "item_id"
    t.datetime "date_time"
    t.string "document_type"
    t.string "item_format"
    t.string "course_id"
    t.boolean "digital_item"
    t.string "course_number"
    t.string "department"
    t.integer "date_time_year"
    t.integer "date_time_month"
    t.integer "date_time_day"
    t.integer "date_time_hour"
  end

  create_table "bookkeeping_data_loads", force: :cascade do |t|
    t.string "table_name"
    t.string "earliest"
    t.string "latest"
  end

  create_table "borrowdirect_bibliographies", force: :cascade do |t|
    t.text "request_number"
    t.string "patron_type", limit: 1
    t.string "author", limit: 300
    t.string "title", limit: 400
    t.string "publisher", limit: 256
    t.string "publication_place", limit: 256
    t.string "publication_year", limit: 4
    t.string "edition", limit: 24
    t.string "lccn", limit: 50
    t.string "isbn", limit: 24
    t.string "isbn_2", limit: 24
    t.datetime "request_date"
    t.datetime "process_date"
    t.string "pickup_location", limit: 64
    t.integer "borrower"
    t.integer "lender"
    t.string "supplier_code", limit: 20
    t.string "call_number", limit: 256
    t.bigint "oclc"
    t.string "oclc_text", limit: 25
    t.string "local_item_found", limit: 1
    t.boolean "is_legacy", default: false, null: false
    t.index ["borrower", "lender", "request_number", "patron_type"], name: "borrowdirect_bibliographies_composite_idx"
    t.index ["borrower"], name: "index_borrowdirect_bibliographies_on_borrower"
    t.index ["call_number"], name: "index_borrowdirect_bibliographies_on_call_number", using: :hash
    t.index ["lender"], name: "index_borrowdirect_bibliographies_on_lender"
    t.index ["patron_type"], name: "index_borrowdirect_bibliographies_on_patron_type"
    t.index ["request_number"], name: "index_borrowdirect_bibliographies_on_request_number"
    t.index ["supplier_code"], name: "index_borrowdirect_bibliographies_on_supplier_code"
  end

  create_table "borrowdirect_call_numbers", force: :cascade do |t|
    t.string "request_number", limit: 12
    t.integer "holdings_seq"
    t.string "supplier_code", limit: 20
    t.string "call_number", limit: 256
    t.datetime "process_date"
    t.boolean "is_legacy", default: false, null: false
    t.index ["call_number"], name: "index_borrowdirect_call_numbers_on_call_number", using: :hash
    t.index ["supplier_code"], name: "index_borrowdirect_call_numbers_on_supplier_code"
  end

  create_table "borrowdirect_exception_codes", force: :cascade do |t|
    t.string "exception_code", limit: 3, null: false
    t.string "exception_code_desc", limit: 64
    t.boolean "is_legacy", default: false, null: false
    t.index ["exception_code"], name: "index_borrowdirect_exception_codes_on_exception_code"
  end

  create_table "borrowdirect_institutions", force: :cascade do |t|
    t.integer "library_id", null: false
    t.string "library_symbol", limit: 25, null: false
    t.string "institution_name", limit: 100
    t.string "prime_post_zipcode", limit: 16
    t.decimal "weighting_factor", precision: 5, scale: 2
    t.index ["library_id"], name: "index_borrowdirect_institutions_on_library_id"
  end

  create_table "borrowdirect_min_ship_dates", force: :cascade do |t|
    t.string "request_number", limit: 12, null: false
    t.datetime "min_ship_date", null: false
    t.boolean "is_legacy", default: false, null: false
    t.index ["request_number"], name: "index_borrowdirect_min_ship_dates_on_request_number"
  end

  create_table "borrowdirect_patron_types", force: :cascade do |t|
    t.string "patron_type", limit: 1, null: false
    t.string "patron_type_desc", limit: 50
    t.boolean "is_legacy", default: false, null: false
    t.index ["patron_type"], name: "index_borrowdirect_patron_types_on_patron_type"
  end

  create_table "borrowdirect_print_dates", force: :cascade do |t|
    t.string "request_number", limit: 12
    t.datetime "print_date"
    t.string "note", limit: 256
    t.datetime "process_date"
    t.integer "library_id"
    t.boolean "is_legacy", default: false, null: false
    t.index ["request_number"], name: "index_borrowdirect_print_dates_on_request_number"
  end

  create_table "borrowdirect_ship_dates", force: :cascade do |t|
    t.text "request_number"
    t.datetime "ship_date", null: false
    t.string "exception_code", limit: 3
    t.datetime "process_date"
    t.boolean "is_legacy", default: false, null: false
    t.index ["exception_code"], name: "index_borrowdirect_ship_dates_on_exception_code"
    t.index ["request_number", "exception_code"], name: "borrowdirect_ship_dates_composite_idx"
    t.index ["request_number"], name: "index_borrowdirect_ship_dates_on_request_number"
  end

  create_table "consultation_interactions", force: :cascade do |t|
    t.datetime "submitted"
    t.string "consultation_or_instruction"
    t.string "staff_pennkey"
    t.string "staff_expertise"
    t.date "event_date"
    t.string "mode_of_consultation"
    t.string "session_type"
    t.string "service_provided"
    t.string "rtg"
    t.string "outcome"
    t.string "research_community"
    t.integer "total_attendance"
    t.integer "number_of_registrations"
    t.string "location"
    t.integer "event_length"
    t.integer "prep_time"
    t.integer "number_of_interactions"
    t.string "patron_type"
    t.string "patron_name"
    t.integer "graduation_year"
    t.string "undergraduate_student_type"
    t.string "graduate_student_type"
    t.string "mba_type"
    t.string "campus"
    t.string "school_affiliation"
    t.string "department"
    t.string "faculty_sponsor"
    t.string "course_sponsor"
    t.string "course_name"
    t.string "course_number"
    t.string "referral_method"
    t.string "patron_question"
    t.text "session_description"
    t.text "notes"
    t.boolean "upload_record", default: true
    t.boolean "returning_user"
    t.index ["outcome"], name: "index_consultation_interactions_on_outcome"
    t.index ["patron_question"], name: "index_consultation_interactions_on_patron_question"
    t.index ["staff_pennkey"], name: "index_consultation_interactions_on_staff_pennkey"
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "ezborrow_bibliographies", force: :cascade do |t|
    t.string "request_number", limit: 12
    t.string "patron_id", limit: 20
    t.string "patron_type", limit: 1
    t.string "author", limit: 300
    t.string "title", limit: 400
    t.string "publisher", limit: 256
    t.string "publication_place", limit: 256
    t.string "publication_year", limit: 4
    t.string "edition", limit: 24
    t.string "lccn", limit: 32
    t.string "isbn", limit: 24
    t.string "isbn_2", limit: 24
    t.integer "oclc"
    t.datetime "request_date"
    t.datetime "process_date"
    t.string "pickup_location", limit: 64
    t.integer "borrower"
    t.integer "lender"
    t.string "supplier_code", limit: 20
    t.string "call_number", limit: 256
    t.string "local_item_found", limit: 1
    t.string "publication_date", limit: 255
    t.boolean "is_legacy", default: false, null: false
  end

  create_table "ezborrow_call_numbers", force: :cascade do |t|
    t.string "request_number", limit: 12
    t.integer "holdings_seq"
    t.string "supplier_code", limit: 20
    t.string "call_number", limit: 256
    t.datetime "process_date"
    t.boolean "is_legacy", default: false, null: false
    t.index ["call_number"], name: "index_ezborrow_call_numbers_on_call_number", using: :hash
    t.index ["request_number"], name: "index_ezborrow_call_numbers_on_request_number"
    t.index ["supplier_code"], name: "index_ezborrow_call_numbers_on_supplier_code"
  end

  create_table "ezborrow_exception_codes", force: :cascade do |t|
    t.string "exception_code", limit: 3, null: false
    t.string "exception_code_desc", limit: 64
    t.boolean "is_legacy", default: false, null: false
  end

  create_table "ezborrow_institutions", force: :cascade do |t|
    t.integer "library_id", null: false
    t.string "library_symbol", limit: 25, null: false
    t.string "institution_name", limit: 100
    t.string "prime_post_zipcode", limit: 16
    t.decimal "weighting_factor", precision: 5, scale: 2
  end

  create_table "ezborrow_min_ship_dates", force: :cascade do |t|
    t.string "request_number", limit: 12, null: false
    t.datetime "min_ship_date", null: false
    t.boolean "is_legacy", default: false, null: false
  end

  create_table "ezborrow_patron_types", force: :cascade do |t|
    t.string "patron_type", limit: 1, null: false
    t.string "patron_type_desc", limit: 32
    t.boolean "is_legacy", default: false, null: false
  end

  create_table "ezborrow_print_dates", force: :cascade do |t|
    t.string "request_number", limit: 12
    t.datetime "print_date"
    t.string "note", limit: 256
    t.datetime "process_date"
    t.integer "library_id"
    t.boolean "is_legacy", default: false, null: false
  end

  create_table "ezborrow_ship_dates", force: :cascade do |t|
    t.string "request_number", limit: 12
    t.datetime "ship_date"
    t.string "exception_code", limit: 3
    t.datetime "process_date"
    t.boolean "is_legacy", default: false, null: false
  end

  create_table "ezpaarse_jobs", force: :cascade do |t|
    t.string "file_name"
    t.date "log_date"
    t.text "message"
    t.datetime "run_date"
  end

  create_table "file_upload_import_logs", force: :cascade do |t|
    t.bigint "file_upload_import_id", null: false
    t.datetime "log_datetime", null: false
    t.string "log_text"
    t.integer "sequence", null: false
    t.index ["file_upload_import_id"], name: "index_file_upload_import_logs_on_file_upload_import_id"
  end

  create_table "file_upload_imports", force: :cascade do |t|
    t.string "target_model", null: false
    t.string "comments"
    t.integer "uploaded_by_id"
    t.datetime "uploaded_at", null: false
    t.string "status"
    t.datetime "last_attempted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "total_rows_to_process"
    t.integer "n_rows_processed"
    t.string "post_sql_to_execute"
  end

  create_table "gate_count_card_swipes", force: :cascade do |t|
    t.datetime "swipe_date"
    t.string "door_name"
    t.string "affiliation_desc"
    t.string "center_desc"
    t.string "dept_desc"
    t.string "usc_desc"
    t.string "card_num"
    t.string "first_name"
    t.string "last_name"
    t.index ["affiliation_desc"], name: "index_gate_count_card_swipes_on_affiliation_desc"
    t.index ["center_desc"], name: "index_gate_count_card_swipes_on_center_desc"
    t.index ["dept_desc"], name: "index_gate_count_card_swipes_on_dept_desc"
    t.index ["door_name"], name: "index_gate_count_card_swipes_on_door_name"
    t.index ["usc_desc"], name: "index_gate_count_card_swipes_on_usc_desc"
  end

  create_table "geo_data_zip_codes", force: :cascade do |t|
    t.string "zip_code"
    t.string "latitude"
    t.string "longitude"
  end

  create_table "illiad_borrowings", force: :cascade do |t|
    t.bigint "institution_id", null: false
    t.string "request_type", limit: 255, null: false
    t.datetime "transaction_date", null: false
    t.bigint "transaction_number", null: false
    t.string "transaction_status", limit: 255, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_legacy", default: false, null: false
    t.index ["institution_id"], name: "index_illiad_borrowings_on_institution_id"
    t.index ["transaction_number"], name: "index_illiad_borrowings_on_transaction_number"
    t.index ["transaction_status"], name: "index_illiad_borrowings_on_transaction_status"
  end

  create_table "illiad_doc_del_trackings", force: :cascade do |t|
    t.bigint "institution_id", null: false
    t.datetime "arrival_date"
    t.datetime "completion_date"
    t.string "completion_status", limit: 255
    t.string "request_type", limit: 255, null: false
    t.bigint "transaction_number", null: false
    t.float "turnaround"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_legacy", default: false, null: false
    t.index ["institution_id"], name: "index_illiad_doc_del_trackings_on_institution_id"
  end

  create_table "illiad_doc_dels", force: :cascade do |t|
    t.bigint "institution_id", null: false
    t.string "request_type", limit: 255, null: false
    t.string "status", limit: 255, null: false
    t.datetime "transaction_date", null: false
    t.bigint "transaction_number", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_legacy", default: false, null: false
    t.index ["institution_id"], name: "index_illiad_doc_dels_on_institution_id"
  end

  create_table "illiad_groups", force: :cascade do |t|
    t.bigint "institution_id", null: false
    t.string "group_name", limit: 255, null: false
    t.integer "group_no", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_legacy", default: false, null: false
    t.index ["institution_id"], name: "index_illiad_groups_on_institution_id"
  end

  create_table "illiad_history_records", force: :cascade do |t|
    t.bigint "institution_id", null: false
    t.bigint "transaction_number", null: false
    t.datetime "record_datetime", null: false
    t.string "entry", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_legacy", default: false, null: false
    t.index ["institution_id"], name: "index_illiad_history_records_on_institution_id"
  end

  create_table "illiad_lender_groups", force: :cascade do |t|
    t.bigint "institution_id", null: false
    t.integer "group_no", null: false
    t.string "lender_code", limit: 255, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_legacy", default: false, null: false
    t.index ["institution_id"], name: "index_illiad_lender_groups_on_institution_id"
  end

  create_table "illiad_lender_infos", force: :cascade do |t|
    t.bigint "institution_id", null: false
    t.string "address", limit: 328
    t.string "billing_category", limit: 255
    t.string "lender_code", limit: 255, null: false
    t.string "library_name", limit: 255
    t.integer "address_number"
    t.string "nvtgc", limit: 255
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_legacy", default: false, null: false
    t.index ["institution_id"], name: "index_illiad_lender_infos_on_institution_id"
  end

  create_table "illiad_lending_trackings", force: :cascade do |t|
    t.bigint "institution_id", null: false
    t.datetime "arrival_date"
    t.datetime "completion_date"
    t.string "completion_status", limit: 255
    t.string "request_type", limit: 255, null: false
    t.bigint "transaction_number", null: false
    t.float "turnaround"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_legacy", default: false, null: false
    t.index ["institution_id"], name: "index_illiad_lending_trackings_on_institution_id"
  end

  create_table "illiad_lendings", force: :cascade do |t|
    t.bigint "institution_id", null: false
    t.string "request_type", limit: 255, null: false
    t.string "status", limit: 255, null: false
    t.datetime "transaction_date", null: false
    t.bigint "transaction_number", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_legacy", default: false, null: false
    t.index ["institution_id"], name: "index_illiad_lendings_on_institution_id"
  end

  create_table "illiad_reference_numbers", force: :cascade do |t|
    t.bigint "institution_id", null: false
    t.string "oclc", limit: 255
    t.string "ref_number", limit: 255
    t.string "ref_type", limit: 255
    t.bigint "transaction_number", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_legacy", default: false, null: false
    t.index ["institution_id"], name: "index_illiad_reference_numbers_on_institution_id"
  end

  create_table "illiad_trackings", force: :cascade do |t|
    t.bigint "institution_id", null: false
    t.datetime "order_date"
    t.string "process_type", limit: 255, null: false
    t.datetime "receive_date"
    t.datetime "request_date"
    t.string "request_type", limit: 255, null: false
    t.datetime "ship_date"
    t.bigint "transaction_number", null: false
    t.float "turnaround_req_rec"
    t.float "turnaround_req_shp"
    t.float "turnaround_shp_rec"
    t.boolean "turnarounds_processed", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_legacy", default: false, null: false
    t.string "completion_status"
    t.index ["institution_id"], name: "index_illiad_trackings_on_institution_id"
    t.index ["order_date"], name: "index_illiad_trackings_on_order_date"
  end

  create_table "illiad_transactions", force: :cascade do |t|
    t.bigint "institution_id", null: false
    t.string "billing_amount", limit: 255
    t.string "call_number", limit: 255
    t.string "cited_in", limit: 10000
    t.string "esp_number", limit: 255
    t.string "ifm_cost", limit: 255
    t.string "in_process_date", limit: 255
    t.string "issn", limit: 255
    t.string "lender_codes", limit: 255
    t.string "lending_library", limit: 255
    t.string "loan_author", limit: 255
    t.string "loan_date", limit: 255
    t.string "loan_edition", limit: 255
    t.string "loan_location", limit: 255
    t.string "loan_publisher", limit: 255
    t.string "loan_title", limit: 500
    t.string "location", limit: 255
    t.string "photo_article_author", limit: 255
    t.string "photo_article_title", limit: 500
    t.string "photo_journal_inclusive_pages", limit: 255
    t.string "photo_journal_issue", limit: 255
    t.string "photo_journal_month", limit: 255
    t.string "photo_journal_title", limit: 500
    t.string "photo_journal_volume", limit: 255
    t.string "photo_journal_year", limit: 255
    t.string "process_type", limit: 255
    t.string "reason_for_cancellation", limit: 255
    t.string "request_type", limit: 255
    t.string "system_id", limit: 255
    t.datetime "transaction_date"
    t.bigint "transaction_number", null: false
    t.string "transaction_status", limit: 255
    t.string "borrower_nvtgc", limit: 255
    t.string "original_nvtgc", limit: 255
    t.datetime "creation_date"
    t.integer "lender_address_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_legacy", default: false, null: false
    t.index ["institution_id"], name: "index_illiad_transactions_on_institution_id"
  end

  create_table "illiad_user_infos", force: :cascade do |t|
    t.bigint "institution_id", null: false
    t.string "status", limit: 255
    t.string "department", limit: 255
    t.string "nvtgc", limit: 255
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_legacy", default: false, null: false
    t.index ["institution_id"], name: "index_illiad_user_infos_on_institution_id"
  end

  create_table "institutions", force: :cascade do |t|
    t.string "name", null: false
    t.string "code", null: false
    t.string "zip_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ipeds_cipcodes", force: :cascade do |t|
    t.string "cip_code2010"
    t.text "cip_title2010"
    t.text "action"
    t.string "text_change"
    t.string "cip_code2020"
    t.text "cip_title2020"
  end

  create_table "ipeds_completion_schema", force: :cascade do |t|
    t.string "varname"
    t.string "data_type"
    t.integer "fieldwidth"
    t.string "format"
    t.string "imputationvar"
    t.text "var_title"
  end

  create_table "ipeds_completions", force: :cascade do |t|
    t.integer "year"
    t.integer "unitid"
    t.text "cipcode"
    t.integer "majornum"
    t.integer "awlevel"
    t.integer "ctotalt"
    t.integer "ctotalm"
    t.integer "ctotalw"
    t.integer "caiant"
    t.integer "caianm"
    t.integer "caianw"
    t.integer "casiat"
    t.integer "casiam"
    t.integer "casiaw"
    t.integer "cbkaat"
    t.integer "cbkaam"
    t.integer "cbkaaw"
    t.integer "chispt"
    t.integer "chispm"
    t.integer "chispw"
    t.integer "cnhpit"
    t.integer "cnhpim"
    t.integer "cnhpiw"
    t.integer "cwhitt"
    t.integer "cwhitm"
    t.integer "cwhitw"
    t.integer "c2_mort"
    t.integer "c2_morm"
    t.integer "c2_morw"
    t.integer "cunknt"
    t.integer "cunknm"
    t.integer "cunknw"
    t.integer "cnralt"
    t.integer "cnralm"
    t.integer "cnralw"
  end

  create_table "ipeds_directories", force: :cascade do |t|
    t.integer "unitid"
    t.text "instnm"
    t.text "ialias"
    t.text "addr"
    t.text "city"
    t.string "stabbr"
    t.string "zip"
    t.integer "fips"
    t.integer "obereg"
    t.text "chfnm"
    t.text "chftitle"
    t.text "gentele"
    t.string "ein"
    t.text "duns"
    t.string "opeid"
    t.integer "opeflag"
    t.text "webaddr"
    t.text "adminurl"
    t.text "faidurl"
    t.text "applurl"
    t.text "npricurl"
    t.text "veturl"
    t.text "athurl"
    t.text "disaurl"
    t.integer "sector"
    t.integer "iclevel"
    t.integer "control"
    t.integer "hloffer"
    t.integer "ugoffer"
    t.integer "groffer"
    t.integer "hdegofr1"
    t.integer "deggrant"
    t.integer "hbcu"
    t.integer "hospital"
    t.integer "medical"
    t.integer "tribal"
    t.integer "locale"
    t.integer "openpubl"
    t.string "act"
    t.integer "newid"
    t.integer "deathyr"
    t.text "closedat"
    t.integer "cyactive"
    t.integer "postsec"
    t.integer "pseflag"
    t.integer "pset4_flg"
    t.integer "rptmth"
    t.integer "instcat"
    t.integer "c18_basic"
    t.integer "c18_ipug"
    t.integer "c18_ipgrd"
    t.integer "c18_ugprf"
    t.integer "c18_enprf"
    t.integer "c18_szset"
    t.integer "c15_basic"
    t.integer "ccbasic"
    t.integer "carnegie"
    t.integer "landgrnt"
    t.integer "instsize"
    t.integer "f1_systyp"
    t.text "f1_sysnam"
    t.string "f1_syscod"
    t.integer "cbsa"
    t.integer "cbsatype"
    t.integer "csa"
    t.integer "necta"
    t.integer "countycd"
    t.text "countynm"
    t.integer "cngdstcd"
    t.float "longitud"
    t.float "latitude"
    t.integer "dfrcgid"
    t.integer "dfrcuscg"
  end

  create_table "ipeds_directory_schema", force: :cascade do |t|
    t.string "varname"
    t.string "data_type"
    t.integer "fieldwidth"
    t.string "format"
    t.string "imputationvar"
    t.text "var_title"
  end

  create_table "ipeds_stem_cipcodes", force: :cascade do |t|
    t.string "cip_code_two_digit_series"
    t.string "cip_code_2020"
    t.text "cip_code_title"
  end

  create_table "keyserver_computers", force: :cascade do |t|
    t.string "computer_id"
    t.string "computer_name"
    t.string "computer_platform"
    t.string "computer_protocol"
    t.string "computer_domain"
    t.string "computer_description"
    t.string "computer_division_id"
  end

  create_table "keyserver_cpu_type_terms", force: :cascade do |t|
    t.string "term_id"
    t.string "term_value"
    t.string "term_abbreviation"
  end

  create_table "keyserver_divisions", force: :cascade do |t|
    t.string "division_id"
    t.string "division_server_id"
    t.string "division_name"
    t.string "division_section_id"
    t.string "division_notes"
    t.string "division_flags"
  end

  create_table "keyserver_event_terms", force: :cascade do |t|
    t.string "term_id"
    t.string "term_value"
    t.string "term_abbreviation"
  end

  create_table "keyserver_platform_terms", force: :cascade do |t|
    t.string "term_id"
    t.string "term_value"
    t.string "term_abbreviation"
  end

  create_table "keyserver_programs", force: :cascade do |t|
    t.string "program_id"
    t.string "program_variant"
    t.string "program_variant_name"
    t.string "program_variant_version"
    t.string "program_platform"
    t.string "program_publisher"
    t.string "program_status"
  end

  create_table "keyserver_reason_terms", force: :cascade do |t|
    t.string "term_id"
    t.string "term_value"
    t.string "term_abbreviation"
  end

  create_table "keyserver_status_terms", force: :cascade do |t|
    t.string "term_id"
    t.string "term_value"
    t.string "term_abbreviation"
  end

  create_table "keyserver_usages", force: :cascade do |t|
    t.string "usage_id"
    t.string "usage_event"
    t.string "usage_user_group"
    t.string "usage_division"
    t.datetime "usage_when"
    t.string "usage_time"
    t.datetime "usage_other_time"
  end

  create_table "library_profile_profiles", force: :cascade do |t|
    t.string "metridoc_code"
    t.string "oclc_symbol"
    t.string "bd_symbol"
    t.string "docline_symbol"
    t.string "institution_name"
    t.string "library_name"
    t.string "name_symbol"
    t.string "also_called"
    t.string "zip_code_location"
    t.string "country"
    t.string "null_ignore"
    t.string "palci"
    t.string "trln"
    t.string "btaa"
    t.string "gwla"
    t.string "blc"
    t.string "aserl"
    t.string "viva"
    t.string "bd"
  end

  create_table "log_job_execution_steps", force: :cascade do |t|
    t.bigint "job_execution_id", null: false
    t.string "step_name", null: false
    t.json "step_yml", null: false
    t.datetime "started_at", null: false
    t.datetime "status_set_at", null: false
    t.string "status", null: false
    t.text "log_text"
    t.index ["job_execution_id"], name: "index_log_job_execution_steps_on_job_execution_id"
  end

  create_table "log_job_executions", force: :cascade do |t|
    t.string "source_name", null: false
    t.string "job_type", null: false
    t.string "mac_address"
    t.json "global_yml", null: false
    t.datetime "started_at", null: false
    t.datetime "status_set_at", null: false
    t.string "status", null: false
    t.text "log_text"
  end

  create_table "report_queries", force: :cascade do |t|
    t.bigint "report_template_id"
    t.integer "owner_id", null: false
    t.string "name", null: false
    t.string "comments"
    t.text "select_section"
    t.string "from_section"
    t.string "where_section"
    t.string "group_by_section"
    t.text "order_section"
    t.string "order_direction_section"
    t.string "status"
    t.datetime "last_run_at"
    t.string "last_error_message"
    t.string "output_file_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "total_rows_to_process"
    t.integer "n_rows_processed"
    t.string "full_sql"
    t.index ["report_template_id"], name: "index_report_queries_on_report_template_id"
  end

  create_table "report_query_join_clauses", force: :cascade do |t|
    t.string "keyword"
    t.string "table"
    t.string "on_keys"
    t.bigint "report_query_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["report_query_id"], name: "index_report_query_join_clauses_on_report_query_id"
  end

  create_table "report_template_join_clauses", force: :cascade do |t|
    t.string "keyword"
    t.string "table"
    t.string "on_keys"
    t.bigint "report_template_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["report_template_id"], name: "index_report_template_join_clauses_on_report_template_id"
  end

  create_table "report_templates", force: :cascade do |t|
    t.string "name", null: false
    t.string "comments"
    t.text "select_section"
    t.string "from_section"
    t.string "where_section"
    t.string "group_by_section"
    t.text "order_section"
    t.string "order_direction_section"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "full_sql"
  end

  create_table "reshare_consortial_views", force: :cascade do |t|
    t.string "cv_requester"
    t.string "cv_requester_nice_name"
    t.datetime "cv_date_created"
    t.datetime "cv_last_updated"
    t.string "cv_supplier_nice_name"
    t.string "cv_patron_request_fk"
    t.string "cv_state_fk"
    t.string "cv_code"
  end

  create_table "reshare_directory_entries", force: :cascade do |t|
    t.string "origin"
    t.string "de_id"
    t.bigint "version"
    t.bigint "custom_properties_id"
    t.string "de_slug"
    t.bigint "de_foaf_timestamp"
    t.string "de_foaf_url"
    t.string "de_name"
    t.string "de_status_fk"
    t.string "de_desc"
    t.string "de_parent"
    t.string "de_lms_location_code"
    t.string "de_entry_url"
    t.string "de_phone_number"
    t.string "de_email_address"
    t.string "de_contact_name"
    t.string "de_type_rv_fk"
    t.bigint "de_published_last_update"
    t.string "de_branding_url"
    t.datetime "__start"
  end

  create_table "reshare_patron_requests", force: :cascade do |t|
    t.string "pr_id"
    t.bigint "pr_version"
    t.datetime "pr_date_created"
    t.string "pr_pub_date"
    t.string "pr_edition"
    t.datetime "__start"
  end

  create_table "reshare_req_overdues", force: :cascade do |t|
    t.string "ro_requester"
    t.string "ro_requester_nice_name"
    t.string "ro_hrid"
    t.string "ro_title"
    t.string "ro_requester_sym"
    t.text "ro_requester_url"
    t.string "ro_supplier_sym"
    t.string "ro_req_state"
    t.string "ro_due_date_rs"
    t.datetime "ro_return_shipped_date"
    t.datetime "ro_last_updated"
  end

  create_table "reshare_req_stats", force: :cascade do |t|
    t.string "rs_requester"
    t.string "rs_requester_nice_name"
    t.string "rs_id"
    t.string "rs_req_id"
    t.datetime "rs_date_created"
    t.string "rs_from_status"
    t.string "rs_to_status"
    t.string "rs_message"
  end

  create_table "reshare_rtat_recs", force: :cascade do |t|
    t.string "rtre_requester"
    t.datetime "rtre_date_created"
    t.string "rtre_req_id"
    t.string "rtre_status"
  end

  create_table "reshare_rtat_reqs", force: :cascade do |t|
    t.string "rtr_requester"
    t.string "rtr_requester_nice_name"
    t.string "rtr_hrid"
    t.string "rtr_title"
    t.string "rtr_call_number"
    t.string "rtr_barcode"
    t.string "rtr_supplier"
    t.string "rtr_supplier_nice_name"
    t.datetime "rtr_date_created"
    t.string "rtr_id"
  end

  create_table "reshare_rtat_ships", force: :cascade do |t|
    t.string "rts_requester"
    t.datetime "rts_date_created"
    t.string "rts_req_id"
    t.string "rts_from_status"
    t.string "rts_to_status"
  end

  create_table "reshare_stat_assis", force: :cascade do |t|
    t.string "sta_supplier"
    t.datetime "sta_date_created"
    t.string "sta_req_id"
    t.string "sta_from_status"
    t.string "sta_to_status"
  end

  create_table "reshare_stat_fills", force: :cascade do |t|
    t.string "stf_supplier"
    t.datetime "stf_date_created"
    t.string "stf_req_id"
    t.string "stf_from_status"
    t.string "stf_to_status"
  end

  create_table "reshare_stat_recs", force: :cascade do |t|
    t.string "stre_supplier"
    t.datetime "stre_date_created"
    t.string "stre_req_id"
    t.string "stre_from_status"
    t.string "stre_to_status"
  end

  create_table "reshare_stat_reqs", force: :cascade do |t|
    t.string "str_supplier"
    t.string "str_supplier_nice_name"
    t.string "str_hrid"
    t.string "str_title"
    t.string "str_call_number"
    t.string "str_barcode"
    t.string "str_requester"
    t.string "str_requester_nice_name"
    t.datetime "str_date_created"
    t.string "str_id"
  end

  create_table "reshare_stat_ships", force: :cascade do |t|
    t.string "sts_supplier"
    t.datetime "sts_date_created"
    t.string "sts_req_id"
    t.string "sts_from_status"
    t.string "sts_to_status"
  end

  create_table "reshare_sup_overdues", force: :cascade do |t|
    t.string "so_supplier"
    t.string "so_supplier_nice_name"
    t.string "so_hrid"
    t.string "so_title"
    t.string "so_requester_sym"
    t.text "so_supplier_url"
    t.string "so_supplier_sym"
    t.string "so_res_state"
    t.string "so_due_date_rs"
    t.string "so_local_call_number"
    t.string "so_item_barcode"
    t.datetime "so_last_updated"
  end

  create_table "reshare_sup_stats", force: :cascade do |t|
    t.string "ss_supplier"
    t.string "ss_supplier_nice_name"
    t.string "ss_id"
    t.string "ss_req_id"
    t.datetime "ss_date_created"
    t.string "ss_from_status"
    t.string "ss_to_status"
    t.string "ss_message"
  end

  create_table "reshare_sup_tat_stats", force: :cascade do |t|
    t.string "stst_supplier"
    t.datetime "stst_date_created"
    t.string "stst_req_id"
    t.string "stst_from_status"
    t.string "stst_to_status"
    t.string "stst_message"
  end

  create_table "upenn_alma_demographics", force: :cascade do |t|
    t.string "pennkey", limit: 8, null: false
    t.boolean "status"
    t.date "status_date"
    t.string "statistical_category_1"
    t.string "statistical_category_2"
    t.string "statistical_category_3"
    t.string "statistical_category_4"
    t.string "statistical_category_5"
    t.text "penn_id", null: false
    t.text "first_name"
    t.text "last_name"
    t.text "email"
    t.text "user_group"
    t.string "school"
    t.index ["pennkey", "penn_id"], name: "index_upenn_alma_demographics_on_pennkey_and_penn_id", unique: true
    t.index ["statistical_category_1"], name: "index_upenn_alma_demographics_on_statistical_category_1"
    t.index ["statistical_category_2"], name: "index_upenn_alma_demographics_on_statistical_category_2"
    t.index ["statistical_category_3"], name: "index_upenn_alma_demographics_on_statistical_category_3"
    t.index ["statistical_category_4"], name: "index_upenn_alma_demographics_on_statistical_category_4"
    t.index ["statistical_category_5"], name: "index_upenn_alma_demographics_on_statistical_category_5"
  end

  create_table "upenn_alma_departments", force: :cascade do |t|
    t.string "department_code"
    t.string "school"
  end

  create_table "upenn_alma_divisions", force: :cascade do |t|
    t.string "division"
    t.string "division_description"
    t.string "school"
  end

  create_table "upenn_ezproxy_ezpaarse_jobs", force: :cascade do |t|
    t.datetime "datetime"
    t.string "login"
    t.string "platform"
    t.string "platform_name"
    t.string "rtype"
    t.string "mime"
    t.string "print_identifier"
    t.string "online_identifier"
    t.string "title_id"
    t.string "doi"
    t.string "publication_title"
    t.date "publication_date"
    t.string "unitid"
    t.string "domain"
    t.boolean "on_campus"
    t.string "geoip_country", limit: 4
    t.string "geoip_region", limit: 4
    t.string "geoip_city"
    t.float "geoip_latitude"
    t.float "geoip_longitude"
    t.string "host"
    t.string "method", limit: 8
    t.string "url"
    t.string "status", limit: 3
    t.integer "size"
    t.string "referer"
    t.string "session_id"
    t.string "resource_name"
    t.index ["host"], name: "index_upenn_ezproxy_ezpaarse_jobs_on_host"
    t.index ["mime"], name: "index_upenn_ezproxy_ezpaarse_jobs_on_mime"
    t.index ["platform"], name: "index_upenn_ezproxy_ezpaarse_jobs_on_platform"
    t.index ["platform_name"], name: "index_upenn_ezproxy_ezpaarse_jobs_on_platform_name"
    t.index ["rtype"], name: "index_upenn_ezproxy_ezpaarse_jobs_on_rtype"
  end

  create_table "ups_zones", force: :cascade do |t|
    t.string "from_prefix", null: false
    t.string "to_prefix", null: false
    t.integer "zone", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_role_sections", force: :cascade do |t|
    t.bigint "user_role_id", null: false
    t.string "section", null: false
    t.string "access_level", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_role_id"], name: "index_user_role_sections_on_user_role_id"
  end

  create_table "user_roles", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "admin_users", "user_roles"
  add_foreign_key "file_upload_import_logs", "file_upload_imports"
  add_foreign_key "user_role_sections", "user_roles"
end

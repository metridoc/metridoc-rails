# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_10_22_132227) do
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
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", precision: nil, null: false
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "admin_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: nil
    t.datetime "remember_created_at", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.boolean "super_admin", default: false, null: false
    t.integer "user_role_id"
    t.string "first_name"
    t.string "last_name"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "alma_circulations", force: :cascade do |t|
    t.decimal "item_loan_id"
    t.date "last_status_update"
    t.string "process_status"
    t.string "loan_status"
    t.string "physical_item_material_type"
    t.string "bibliographic_material_type"
    t.string "bibliographic_resource_type"
    t.decimal "loan_fiscal_year"
    t.decimal "loan_year"
    t.date "loan_date"
    t.decimal "renewals"
    t.date "due_date"
    t.date "original_due_date"
    t.date "return_date"
    t.string "policy_name"
    t.string "library_name"
    t.string "location_name"
    t.string "title"
    t.string "title_normalized"
    t.string "author"
    t.string "physical_item_id"
    t.string "barcode"
    t.string "mms_id"
    t.string "isbn"
    t.string "isbn_normalized"
    t.string "issn"
    t.string "issn_normalized"
    t.string "oclc_control_number_019"
    t.string "oclc_control_number_035a"
    t.string "oclc_control_number_035z"
    t.string "oclc_control_number_035az"
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
    t.string "first_name"
    t.string "last_name"
    t.string "preferred_email"
    t.string "penn_id_number"
    t.string "user_id"
    t.string "user_group"
    t.string "school"
    t.string "statistical_category_1"
    t.string "statistical_category_2"
    t.string "statistical_category_3"
    t.string "statistical_category_4"
    t.string "statistical_category_5"
    t.date "item_creation"
    t.index ["bibliographic_material_type"], name: "alma_circulations_bibliographic_material_type"
    t.index ["bibliographic_resource_type"], name: "alma_circulations_bibliographic_resource_type"
    t.index ["item_loan_id"], name: "alma_circulations_item_loan_id", unique: true
    t.index ["last_status_update"], name: "alma_circulations_last_status_update"
    t.index ["library_name"], name: "alma_circulations_library_name"
    t.index ["loan_status"], name: "alma_circulations_loan_status"
    t.index ["location_name"], name: "alma_circulations_location_name"
    t.index ["physical_item_material_type"], name: "alma_circulations_physical_item_material_type"
    t.index ["process_status"], name: "alma_circulations_process_status"
    t.index ["school"], name: "alma_circulations_school"
    t.index ["user_group"], name: "alma_circulations_user_group"
  end

  create_table "bd_reshare_borrowing_turnarounds", force: :cascade do |t|
    t.string "borrower"
    t.string "request_id"
    t.datetime "request_date", precision: nil
    t.datetime "shipped_date", precision: nil
    t.datetime "received_date", precision: nil
    t.decimal "time_to_ship"
    t.decimal "time_to_receipt"
    t.decimal "total_time"
    t.integer "fiscal_year"
    t.index ["borrower", "request_id"], name: "bd_borrowing_turnaround_index", unique: true
  end

  create_table "bd_reshare_directory_entries", force: :cascade do |t|
    t.string "origin"
    t.string "de_id"
    t.bigint "version"
    t.string "de_slug"
    t.string "de_name"
    t.string "de_status_fk"
    t.string "de_parent"
    t.string "de_lms_location_code"
    t.datetime "last_updated", precision: nil
    t.index ["origin", "de_id"], name: "bd_directory_entry_index", unique: true
  end

  create_table "bd_reshare_host_lms_locations", force: :cascade do |t|
    t.string "hll_id"
    t.string "origin"
    t.datetime "hll_date_created", precision: nil
    t.datetime "hll_last_updated", precision: nil
    t.integer "hll_version"
    t.string "hll_code"
    t.string "hll_name"
    t.integer "hll_supply_preference"
    t.string "hll_corresponding_de"
    t.boolean "hll_hidden"
    t.index ["hll_id"], name: "bd_reshare_location_index", unique: true
  end

  create_table "bd_reshare_host_lms_shelving_locations", force: :cascade do |t|
    t.string "hlsl_id"
    t.string "origin"
    t.datetime "hlsl_date_created", precision: nil
    t.datetime "hlsl_last_updated", precision: nil
    t.integer "hlsl_version"
    t.string "hlsl_code"
    t.string "hlsl_name"
    t.integer "hlsl_supply_preference"
    t.boolean "hlsl_hidden"
    t.index ["hlsl_id"], name: "bd_reshare_shelving_location_index", unique: true
  end

  create_table "bd_reshare_lending_turnarounds", force: :cascade do |t|
    t.string "lender"
    t.string "request_id"
    t.datetime "request_date", precision: nil
    t.datetime "filled_date", precision: nil
    t.datetime "shipped_date", precision: nil
    t.datetime "received_date", precision: nil
    t.decimal "time_to_fill"
    t.decimal "time_to_ship"
    t.decimal "time_to_receipt"
    t.decimal "total_time"
    t.integer "fiscal_year"
    t.index ["lender", "request_id"], name: "bd_lending_turnaround_index", unique: true
  end

  create_table "bd_reshare_patron_request_audits", force: :cascade do |t|
    t.datetime "last_updated", precision: nil
    t.string "origin"
    t.string "pra_id"
    t.string "pra_version"
    t.datetime "pra_date_created", precision: nil
    t.string "pra_patron_request_fk"
    t.string "pra_from_status_fk"
    t.string "pra_to_status_fk"
    t.string "pra_message"
    t.index ["pra_id"], name: "bd_patron_request_audit_index", unique: true
  end

  create_table "bd_reshare_patron_request_rota", force: :cascade do |t|
    t.datetime "last_updated", precision: nil
    t.string "origin"
    t.string "prr_id"
    t.string "prr_version"
    t.datetime "prr_date_created", precision: nil
    t.datetime "prr_last_updated", precision: nil
    t.integer "prr_rota_position"
    t.string "prr_directory_id_fk"
    t.string "prr_patron_request_fk"
    t.string "prr_state_fk"
    t.string "prr_peer_symbol_fk"
    t.integer "prr_lb_score"
    t.string "prr_lb_reason"
    t.index ["prr_id"], name: "bd_patron_request_rota_index", unique: true
  end

  create_table "bd_reshare_patron_requests", force: :cascade do |t|
    t.string "pr_id"
    t.bigint "pr_version"
    t.datetime "pr_date_created", precision: nil
    t.string "pr_pub_date"
    t.datetime "last_updated", precision: nil
    t.string "origin"
    t.string "pr_hrid"
    t.string "pr_patron_type"
    t.string "pr_resolved_req_inst_symbol_fk"
    t.string "pr_resolved_pickup_location_fk"
    t.string "pr_pickup_location_slug"
    t.string "pr_resolved_sup_inst_symbol_fk"
    t.string "pr_pick_location_fk"
    t.string "pr_pick_shelving_location"
    t.string "pr_title"
    t.string "pr_local_call_number"
    t.string "pr_selected_item_barcode"
    t.string "pr_oclc_number"
    t.string "pr_publisher"
    t.string "pr_place_of_pub"
    t.string "pr_bib_record"
    t.string "pr_state_fk"
    t.integer "pr_rota_position"
    t.boolean "pr_is_requester"
    t.datetime "pr_due_date_from_lms", precision: nil
    t.datetime "pr_parsed_due_date_lms", precision: nil
    t.datetime "pr_due_date_rs", precision: nil
    t.datetime "pr_parsed_due_date_rs", precision: nil
    t.boolean "pr_overdue"
    t.string "pr_pick_shelving_location_fk"
    t.string "pr_patron_identifier"
    t.index ["pr_id"], name: "bd_patron_requests_index", unique: true
  end

  create_table "bd_reshare_status", force: :cascade do |t|
    t.datetime "last_updated", precision: nil
    t.string "origin"
    t.string "st_id"
    t.string "st_version"
    t.string "st_code"
    t.index ["st_id"], name: "bd_status_index", unique: true
  end

  create_table "bd_reshare_symbols", force: :cascade do |t|
    t.datetime "last_updated", precision: nil
    t.string "origin"
    t.string "sym_id"
    t.string "sym_version"
    t.string "sym_owner_fk"
    t.string "sym_symbol"
    t.index ["sym_id"], name: "bd_symbols_index", unique: true
  end

  create_table "bd_reshare_transactions", force: :cascade do |t|
    t.string "borrower"
    t.string "lender"
    t.string "request_id"
    t.string "borrower_id"
    t.string "lender_id"
    t.datetime "date_created", precision: nil
    t.datetime "borrower_last_updated", precision: nil
    t.datetime "lender_last_updated", precision: nil
    t.string "borrower_status"
    t.string "lender_status"
    t.string "title"
    t.string "publication_date"
    t.string "place_of_publication"
    t.string "publisher"
    t.string "call_number"
    t.string "oclc_number"
    t.string "barcode"
    t.string "pick_location"
    t.string "shelving_location"
    t.string "pickup_location"
    t.integer "fiscal_year"
    t.index ["borrower_id", "lender_id"], name: "bd_transaction_index", unique: true
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
    t.datetime "request_date", precision: nil
    t.datetime "process_date", precision: nil
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
    t.datetime "process_date", precision: nil
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
    t.datetime "min_ship_date", precision: nil, null: false
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
    t.datetime "print_date", precision: nil
    t.string "note", limit: 256
    t.datetime "process_date", precision: nil
    t.integer "library_id"
    t.boolean "is_legacy", default: false, null: false
    t.index ["request_number"], name: "index_borrowdirect_print_dates_on_request_number"
  end

  create_table "borrowdirect_ship_dates", force: :cascade do |t|
    t.text "request_number"
    t.datetime "ship_date", precision: nil, null: false
    t.string "exception_code", limit: 3
    t.datetime "process_date", precision: nil
    t.boolean "is_legacy", default: false, null: false
    t.index ["exception_code"], name: "index_borrowdirect_ship_dates_on_exception_code"
    t.index ["request_number", "exception_code"], name: "borrowdirect_ship_dates_composite_idx"
    t.index ["request_number"], name: "index_borrowdirect_ship_dates_on_request_number"
  end

  create_table "consultation_interactions", force: :cascade do |t|
    t.datetime "submitted", precision: nil
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
    t.string "additional_staff_pennkey"
    t.index ["outcome"], name: "index_consultation_interactions_on_outcome"
    t.index ["patron_question"], name: "index_consultation_interactions_on_patron_question"
    t.index ["staff_pennkey"], name: "index_consultation_interactions_on_staff_pennkey"
  end

  create_table "cr_ares_course_users", force: :cascade do |t|
    t.integer "course_id"
    t.string "user_type"
    t.string "username"
    t.index ["course_id"], name: "cr_ares_course_users_course_id"
    t.index ["user_type"], name: "cr_ares_course_users_user_type"
  end

  create_table "cr_ares_courses", force: :cascade do |t|
    t.integer "course_id"
    t.string "course_code"
    t.string "external_course_id"
    t.string "registrar_course_id"
    t.string "department"
    t.string "semester"
    t.datetime "start_date", precision: nil
    t.datetime "stop_date", precision: nil
    t.decimal "course_enrollment"
    t.string "name"
    t.string "instructor"
    t.string "default_pickup_site"
    t.index ["course_id"], name: "cr_ares_courses_course_id"
    t.index ["semester"], name: "cr_ares_courses_semester"
  end

  create_table "cr_ares_custom_drop_downs", force: :cascade do |t|
    t.string "group_name"
    t.string "label_name"
    t.string "label_value"
  end

  create_table "cr_ares_item_history", force: :cascade do |t|
    t.integer "item_id"
    t.datetime "date_time", precision: nil
    t.string "entry"
    t.string "username"
    t.index ["item_id"], name: "cr_ares_item_history_item_id"
    t.index ["username"], name: "cr_ares_item_history_username"
  end

  create_table "cr_ares_item_trackings", force: :cascade do |t|
    t.integer "item_id"
    t.datetime "tracking_date_time", precision: nil
    t.string "status"
    t.string "username"
    t.index ["item_id"], name: "cr_ares_item_trackings_item_id"
    t.index ["username"], name: "cr_ares_item_trackings_username"
  end

  create_table "cr_ares_items", force: :cascade do |t|
    t.integer "item_id"
    t.integer "course_id"
    t.string "pickup_location"
    t.string "processing_location"
    t.string "current_status"
    t.datetime "current_status_date", precision: nil
    t.string "item_type"
    t.boolean "digital_item"
    t.string "location"
    t.boolean "ares_document"
    t.boolean "copyright_required"
    t.boolean "copyright_obtained"
    t.datetime "active_date", precision: nil
    t.datetime "inactive_date", precision: nil
    t.string "callnumber"
    t.text "reason_for_cancellation"
    t.boolean "proxy"
    t.string "title"
    t.string "author"
    t.string "publisher"
    t.string "pub_place"
    t.string "pub_date"
    t.string "edition"
    t.string "isxn"
    t.string "esp_number"
    t.string "doi"
    t.string "article_title"
    t.string "volume"
    t.string "issue"
    t.string "journal_year"
    t.string "journal_month"
    t.string "shelf_location"
    t.string "document_type"
    t.string "item_format"
    t.text "description"
    t.string "editor"
    t.string "item_barcode"
    t.string "needed_by"
    t.index ["course_id"], name: "cr_ares_items_course_id"
    t.index ["item_id"], name: "cr_ares_items_item_id"
  end

  create_table "cr_ares_semesters", force: :cascade do |t|
    t.string "semester"
    t.datetime "start_date", precision: nil
    t.datetime "end_date", precision: nil
    t.index ["semester"], name: "cr_ares_semesters_semester"
  end

  create_table "cr_ares_sites", force: :cascade do |t|
    t.string "site_code"
    t.string "site_name"
    t.string "default_processing_site"
    t.boolean "available_for_pickup"
    t.boolean "available_for_processing"
  end

  create_table "cr_ares_users", force: :cascade do |t|
    t.string "username"
    t.string "last_name"
    t.string "first_name"
    t.string "library_id"
    t.string "department"
    t.string "status"
    t.string "e_mail_address"
    t.string "user_type"
    t.datetime "last_login_date", precision: nil
    t.string "cleared"
    t.datetime "expiration_date", precision: nil
    t.boolean "trusted"
    t.string "auth_method"
    t.boolean "course_email_default"
    t.string "external_user_id"
    t.index ["user_type"], name: "cr_ares_users_user_type"
    t.index ["username"], name: "cr_ares_users_username"
  end

  create_table "cr_legacy_courses", force: :cascade do |t|
    t.integer "course_id"
    t.string "course_code"
    t.string "registrar_course_id"
    t.string "semester"
    t.string "department"
    t.string "name"
    t.string "default_pickup_site"
    t.string "instructor_pennkey"
    t.integer "instructor_penn_id"
    t.string "instructor_department"
    t.string "instructor_first_name"
    t.string "instructor_last_name"
    t.index ["course_id"], name: "cr_legacy_courses_course_id"
    t.index ["semester"], name: "cr_legacy_courses_semester"
  end

  create_table "cr_legacy_items", force: :cascade do |t|
    t.string "item_id"
    t.integer "course_id"
    t.string "processing_location"
    t.string "location"
    t.string "callnumber"
    t.string "title"
    t.string "author"
    t.string "publisher"
    t.string "pub_place"
    t.string "edition"
    t.string "isxn"
    t.string "volume"
    t.string "document_type"
    t.string "item_format"
    t.string "item_barcode"
    t.index ["course_id"], name: "cr_legacy_items_course_id"
    t.index ["item_id"], name: "cr_legacy_items_item_id"
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at", precision: nil
    t.datetime "locked_at", precision: nil
    t.datetime "failed_at", precision: nil
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
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
    t.datetime "request_date", precision: nil
    t.datetime "process_date", precision: nil
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
    t.datetime "process_date", precision: nil
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
    t.datetime "min_ship_date", precision: nil, null: false
    t.boolean "is_legacy", default: false, null: false
  end

  create_table "ezborrow_patron_types", force: :cascade do |t|
    t.string "patron_type", limit: 1, null: false
    t.string "patron_type_desc", limit: 32
    t.boolean "is_legacy", default: false, null: false
  end

  create_table "ezborrow_print_dates", force: :cascade do |t|
    t.string "request_number", limit: 12
    t.datetime "print_date", precision: nil
    t.string "note", limit: 256
    t.datetime "process_date", precision: nil
    t.integer "library_id"
    t.boolean "is_legacy", default: false, null: false
  end

  create_table "ezborrow_ship_dates", force: :cascade do |t|
    t.string "request_number", limit: 12
    t.datetime "ship_date", precision: nil
    t.string "exception_code", limit: 3
    t.datetime "process_date", precision: nil
    t.boolean "is_legacy", default: false, null: false
  end

  create_table "ezpaarse_hourly_usages", force: :cascade do |t|
    t.integer "fiscal_year"
    t.date "date"
    t.string "day_of_week"
    t.integer "dow_index"
    t.integer "hour_of_day"
    t.integer "requests"
    t.integer "sessions"
  end

  create_table "ezpaarse_jobs", force: :cascade do |t|
    t.string "file_name"
    t.date "log_date"
    t.text "message"
    t.datetime "run_date", precision: nil
  end

  create_table "ezpaarse_logs", force: :cascade do |t|
    t.datetime "datetime", precision: nil
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
    t.string "publication_date"
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
    t.bigint "size"
    t.string "referer"
    t.string "session_id"
    t.string "resource_name"
    t.string "statistical_category_1"
    t.string "statistical_category_2"
    t.string "statistical_category_3"
    t.string "statistical_category_4"
    t.string "statistical_category_5"
    t.text "user_group"
    t.string "school"
    t.text "penn_id"
    t.string "title"
    t.string "type"
    t.string "subject"
    t.string "license"
    t.string "checksum_index"
    t.index ["datetime", "checksum_index"], name: "ezpaarse_logs_index", unique: true
    t.index ["datetime"], name: "index_ezpaarse_logs_on_datetime"
    t.index ["host"], name: "index_ezpaarse_logs_on_host"
    t.index ["mime"], name: "index_ezpaarse_logs_on_mime"
    t.index ["platform"], name: "index_ezpaarse_logs_on_platform"
    t.index ["platform_name"], name: "index_ezpaarse_logs_on_platform_name"
    t.index ["rtype"], name: "index_ezpaarse_logs_on_rtype"
  end

  create_table "ezpaarse_platforms", force: :cascade do |t|
    t.integer "fiscal_year"
    t.string "platform_name"
    t.string "rtype"
    t.string "mime"
    t.integer "requests"
    t.integer "sessions"
  end

  create_table "ezpaarse_user_profiles", force: :cascade do |t|
    t.integer "fiscal_year"
    t.string "user_group"
    t.string "school"
    t.string "country"
    t.string "state"
    t.integer "requests"
    t.integer "sessions"
  end

  create_table "file_upload_import_logs", force: :cascade do |t|
    t.bigint "file_upload_import_id", null: false
    t.datetime "log_datetime", precision: nil, null: false
    t.string "log_text"
    t.integer "sequence", null: false
    t.index ["file_upload_import_id"], name: "index_file_upload_import_logs_on_file_upload_import_id"
  end

  create_table "file_upload_imports", force: :cascade do |t|
    t.string "target_model", null: false
    t.string "comments"
    t.integer "uploaded_by_id"
    t.datetime "uploaded_at", precision: nil, null: false
    t.string "status"
    t.datetime "last_attempted_at", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "total_rows_to_process"
    t.integer "n_rows_processed"
    t.string "post_sql_to_execute"
  end

  create_table "ga_ua_daily_reports", force: :cascade do |t|
    t.integer "property"
    t.integer "fiscal_year"
    t.date "date"
    t.integer "users"
    t.integer "new_users"
    t.integer "sessions"
    t.decimal "sessions_per_user"
    t.integer "bounces"
    t.decimal "bounce_rate"
    t.decimal "session_duration"
    t.decimal "avg_session_duration"
    t.integer "pageviews"
    t.decimal "pageviews_per_session"
    t.index ["date"], name: "index_ga_ua_daily_reports_on_date"
    t.index ["fiscal_year"], name: "index_ga_ua_daily_reports_on_fiscal_year"
    t.index ["property", "fiscal_year", "date"], name: "ga_ua_daily_report_id", unique: true
    t.index ["property"], name: "index_ga_ua_daily_reports_on_property"
  end

  create_table "ga_ua_devices", force: :cascade do |t|
    t.integer "property"
    t.integer "fiscal_year"
    t.date "date"
    t.string "browser"
    t.string "operating_system"
    t.integer "users"
    t.integer "new_users"
    t.integer "sessions"
    t.decimal "sessions_per_user"
    t.integer "bounces"
    t.decimal "bounce_rate"
    t.decimal "session_duration"
    t.decimal "avg_session_duration"
    t.integer "pageviews"
    t.decimal "pageviews_per_session"
    t.index ["browser"], name: "index_ga_ua_devices_on_browser"
    t.index ["date"], name: "index_ga_ua_devices_on_date"
    t.index ["fiscal_year"], name: "index_ga_ua_devices_on_fiscal_year"
    t.index ["operating_system"], name: "index_ga_ua_devices_on_operating_system"
    t.index ["property", "fiscal_year", "date", "browser", "operating_system"], name: "ga_ua_device_id", unique: true
    t.index ["property"], name: "index_ga_ua_devices_on_property"
  end

  create_table "ga_ua_locations", force: :cascade do |t|
    t.integer "property"
    t.integer "fiscal_year"
    t.date "date"
    t.string "continent"
    t.string "sub_continent"
    t.string "country"
    t.string "region"
    t.string "metro"
    t.string "city"
    t.string "country_iso_code"
    t.string "region_iso_code"
    t.integer "users"
    t.integer "new_users"
    t.integer "sessions"
    t.decimal "sessions_per_user"
    t.integer "bounces"
    t.decimal "bounce_rate"
    t.decimal "session_duration"
    t.decimal "avg_session_duration"
    t.integer "pageviews"
    t.decimal "pageviews_per_session"
    t.index ["country_iso_code"], name: "index_ga_ua_locations_on_country_iso_code"
    t.index ["date"], name: "index_ga_ua_locations_on_date"
    t.index ["fiscal_year"], name: "index_ga_ua_locations_on_fiscal_year"
    t.index ["property", "fiscal_year", "date", "country_iso_code", "region_iso_code", "region", "metro", "city"], name: "ga_ua_location_id", unique: true
    t.index ["property"], name: "index_ga_ua_locations_on_property"
    t.index ["region_iso_code"], name: "index_ga_ua_locations_on_region_iso_code"
  end

  create_table "ga_ua_pageviews", force: :cascade do |t|
    t.integer "property"
    t.integer "fiscal_year"
    t.date "date"
    t.string "page_path"
    t.integer "pageviews"
    t.integer "unique_pageviews"
    t.integer "entrances"
    t.decimal "entrance_rate"
    t.integer "exits"
    t.decimal "exit_rate"
    t.integer "bounces"
    t.decimal "bounce_rate"
    t.decimal "time_on_page"
    t.decimal "avg_time_on_page"
    t.index ["date"], name: "index_ga_ua_pageviews_on_date"
    t.index ["fiscal_year"], name: "index_ga_ua_pageviews_on_fiscal_year"
    t.index ["page_path"], name: "index_ga_ua_pageviews_on_page_path"
    t.index ["property", "fiscal_year", "date", "page_path"], name: "ga_ua_pageview_id", unique: true
    t.index ["property"], name: "index_ga_ua_pageviews_on_property"
  end

  create_table "ga_ua_properties", force: :cascade do |t|
    t.integer "property"
    t.string "name"
    t.string "url"
    t.string "description"
    t.index ["property"], name: "index_ga_ua_properties_on_property", unique: true
  end

  create_table "ga_ua_sources", force: :cascade do |t|
    t.integer "property"
    t.integer "fiscal_year"
    t.date "date"
    t.string "source"
    t.integer "users"
    t.integer "new_users"
    t.integer "sessions"
    t.decimal "sessions_per_user"
    t.integer "bounces"
    t.decimal "bounce_rate"
    t.decimal "session_duration"
    t.decimal "avg_session_duration"
    t.integer "pageviews"
    t.decimal "pageviews_per_session"
    t.index ["date"], name: "index_ga_ua_sources_on_date"
    t.index ["fiscal_year"], name: "index_ga_ua_sources_on_fiscal_year"
    t.index ["property", "fiscal_year", "date", "source"], name: "ga_ua_source_id", unique: true
    t.index ["property"], name: "index_ga_ua_sources_on_property"
    t.index ["source"], name: "index_ga_ua_sources_on_source"
  end

  create_table "gate_count_card_swipes", force: :cascade do |t|
    t.datetime "swipe_date", precision: nil
    t.string "door_name"
    t.string "affiliation_desc"
    t.string "center_desc"
    t.string "dept_desc"
    t.string "usc_desc"
    t.string "card_num"
    t.string "first_name"
    t.string "last_name"
    t.string "statistical_category_1"
    t.string "statistical_category_2"
    t.string "statistical_category_3"
    t.string "statistical_category_4"
    t.string "statistical_category_5"
    t.text "user_group"
    t.string "school"
    t.text "pennkey"
    t.index ["affiliation_desc"], name: "index_gate_count_card_swipes_on_affiliation_desc"
    t.index ["center_desc"], name: "index_gate_count_card_swipes_on_center_desc"
    t.index ["dept_desc"], name: "index_gate_count_card_swipes_on_dept_desc"
    t.index ["door_name"], name: "index_gate_count_card_swipes_on_door_name"
    t.index ["usc_desc"], name: "index_gate_count_card_swipes_on_usc_desc"
  end

  create_table "geo_data_country_codes", force: :cascade do |t|
    t.string "iso3166_1_alpha_3"
    t.string "iso3166_1_numeric"
    t.string "iso3166_alpha_2"
    t.string "cldr_display_name"
    t.string "unterm_english_short"
    t.string "unterm_english_official"
    t.string "region_name"
    t.string "sub_region_name"
    t.string "capital"
    t.string "marc"
    t.string "fips"
  end

  create_table "geo_data_zip_codes", force: :cascade do |t|
    t.string "zip_code"
    t.string "latitude"
    t.string "longitude"
  end

  create_table "illiad_borrowings", force: :cascade do |t|
    t.bigint "institution_id", null: false
    t.string "request_type", limit: 255, null: false
    t.datetime "transaction_date", precision: nil, null: false
    t.bigint "transaction_number", null: false
    t.string "transaction_status", limit: 255, null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.boolean "is_legacy", default: false, null: false
    t.index ["institution_id"], name: "index_illiad_borrowings_on_institution_id"
    t.index ["transaction_number"], name: "index_illiad_borrowings_on_transaction_number"
    t.index ["transaction_status"], name: "index_illiad_borrowings_on_transaction_status"
  end

  create_table "illiad_doc_del_trackings", force: :cascade do |t|
    t.bigint "institution_id", null: false
    t.datetime "arrival_date", precision: nil
    t.datetime "completion_date", precision: nil
    t.string "completion_status", limit: 255
    t.string "request_type", limit: 255, null: false
    t.bigint "transaction_number", null: false
    t.float "turnaround"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.boolean "is_legacy", default: false, null: false
    t.index ["institution_id"], name: "index_illiad_doc_del_trackings_on_institution_id"
  end

  create_table "illiad_doc_dels", force: :cascade do |t|
    t.bigint "institution_id", null: false
    t.string "request_type", limit: 255, null: false
    t.string "status", limit: 255, null: false
    t.datetime "transaction_date", precision: nil, null: false
    t.bigint "transaction_number", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.boolean "is_legacy", default: false, null: false
    t.index ["institution_id"], name: "index_illiad_doc_dels_on_institution_id"
  end

  create_table "illiad_groups", force: :cascade do |t|
    t.bigint "institution_id", null: false
    t.string "group_name", limit: 255, null: false
    t.integer "group_no", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.boolean "is_legacy", default: false, null: false
    t.index ["institution_id"], name: "index_illiad_groups_on_institution_id"
  end

  create_table "illiad_history_records", force: :cascade do |t|
    t.bigint "institution_id", null: false
    t.bigint "transaction_number", null: false
    t.datetime "record_datetime", precision: nil, null: false
    t.string "entry", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.boolean "is_legacy", default: false, null: false
    t.index ["institution_id"], name: "index_illiad_history_records_on_institution_id"
  end

  create_table "illiad_lender_groups", force: :cascade do |t|
    t.bigint "institution_id", null: false
    t.integer "group_no", null: false
    t.string "lender_code", limit: 255, null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
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
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.boolean "is_legacy", default: false, null: false
    t.index ["institution_id"], name: "index_illiad_lender_infos_on_institution_id"
  end

  create_table "illiad_lending_trackings", force: :cascade do |t|
    t.bigint "institution_id", null: false
    t.datetime "arrival_date", precision: nil
    t.datetime "completion_date", precision: nil
    t.string "completion_status", limit: 255
    t.string "request_type", limit: 255, null: false
    t.bigint "transaction_number", null: false
    t.float "turnaround"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.boolean "is_legacy", default: false, null: false
    t.index ["institution_id"], name: "index_illiad_lending_trackings_on_institution_id"
  end

  create_table "illiad_lendings", force: :cascade do |t|
    t.bigint "institution_id", null: false
    t.string "request_type", limit: 255, null: false
    t.string "status", limit: 255, null: false
    t.datetime "transaction_date", precision: nil, null: false
    t.bigint "transaction_number", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.boolean "is_legacy", default: false, null: false
    t.index ["institution_id"], name: "index_illiad_lendings_on_institution_id"
  end

  create_table "illiad_reference_numbers", force: :cascade do |t|
    t.bigint "institution_id", null: false
    t.string "oclc", limit: 255
    t.string "ref_number", limit: 255
    t.string "ref_type", limit: 255
    t.bigint "transaction_number", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.boolean "is_legacy", default: false, null: false
    t.index ["institution_id"], name: "index_illiad_reference_numbers_on_institution_id"
  end

  create_table "illiad_trackings", force: :cascade do |t|
    t.bigint "institution_id", null: false
    t.datetime "order_date", precision: nil
    t.string "process_type", limit: 255, null: false
    t.datetime "receive_date", precision: nil
    t.datetime "request_date", precision: nil
    t.string "request_type", limit: 255, null: false
    t.datetime "ship_date", precision: nil
    t.bigint "transaction_number", null: false
    t.float "turnaround_req_rec"
    t.float "turnaround_req_shp"
    t.float "turnaround_shp_rec"
    t.boolean "turnarounds_processed", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
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
    t.datetime "transaction_date", precision: nil
    t.bigint "transaction_number", null: false
    t.string "transaction_status", limit: 255
    t.string "borrower_nvtgc", limit: 255
    t.string "original_nvtgc", limit: 255
    t.datetime "creation_date", precision: nil
    t.integer "lender_address_number"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.boolean "is_legacy", default: false, null: false
    t.index ["institution_id"], name: "index_illiad_transactions_on_institution_id"
  end

  create_table "illiad_user_infos", force: :cascade do |t|
    t.bigint "institution_id", null: false
    t.string "status", limit: 255
    t.string "department", limit: 255
    t.string "nvtgc", limit: 255
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.boolean "is_legacy", default: false, null: false
    t.index ["institution_id"], name: "index_illiad_user_infos_on_institution_id"
  end

  create_table "institutions", force: :cascade do |t|
    t.string "name", null: false
    t.string "code", null: false
    t.string "zip_code"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "ipeds_cipcodes", force: :cascade do |t|
    t.string "cip_code2010"
    t.text "cip_title2010"
    t.text "action"
    t.string "text_change"
    t.string "cip_code2020"
    t.text "cip_title2020"
    t.index ["cip_code2010", "cip_code2020"], name: "ipeds_cipcodes_unique_id", unique: true
  end

  create_table "ipeds_completion_schema", force: :cascade do |t|
    t.string "varname"
    t.string "data_type"
    t.integer "fieldwidth"
    t.string "format"
    t.string "imputationvar"
    t.text "var_title"
    t.index ["varname"], name: "ipeds_completion_schema_unique_id", unique: true
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
    t.index ["year", "unitid", "cipcode", "majornum", "awlevel"], name: "ipeds_completions_unique_id", unique: true
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
    t.index ["unitid"], name: "ipeds_directories_unique_id", unique: true
  end

  create_table "ipeds_directory_schema", force: :cascade do |t|
    t.string "varname"
    t.string "data_type"
    t.integer "fieldwidth"
    t.string "format"
    t.string "imputationvar"
    t.text "var_title"
    t.index ["varname"], name: "ipeds_directory_schema_unique_id", unique: true
  end

  create_table "ipeds_program_schema", force: :cascade do |t|
    t.string "varname"
    t.string "data_type"
    t.integer "fieldwidth"
    t.string "format"
    t.string "imputationvar"
    t.text "var_title"
    t.index ["varname"], name: "ipeds_program_schema_unique_id", unique: true
  end

  create_table "ipeds_programs", force: :cascade do |t|
    t.integer "year"
    t.integer "unitid"
    t.text "cipcode"
    t.integer "ptotal"
    t.integer "ptotalde"
    t.integer "ptotaldes"
    t.integer "passoc"
    t.integer "passocde"
    t.integer "passocdes"
    t.integer "pbachl"
    t.integer "pbachlde"
    t.integer "pbachldes"
    t.integer "pmastr"
    t.integer "pmastrde"
    t.integer "pmastrdes"
    t.integer "pdocrs"
    t.integer "pdocrsde"
    t.integer "pdocrsdes"
    t.integer "pdocpp"
    t.integer "pdocppde"
    t.integer "pdocppdes"
    t.integer "pdocot"
    t.integer "pdocotde"
    t.integer "pdocotdes"
    t.integer "pcert1"
    t.integer "pcert1_de"
    t.integer "pcert1_a"
    t.integer "pcert1_ade"
    t.integer "pcert1_ades"
    t.integer "pcert1_b"
    t.integer "pcert1_bde"
    t.integer "pcert1_bdes"
    t.integer "pcert2"
    t.integer "pcert2_de"
    t.integer "pcert2_des"
    t.integer "pcert4"
    t.integer "pcert4_de"
    t.integer "pcert4_des"
    t.integer "ppbacc"
    t.integer "ppbaccde"
    t.integer "ppbaccdes"
    t.integer "ppmast"
    t.integer "ppmastde"
    t.integer "ppmastdes"
    t.index ["year", "unitid", "cipcode"], name: "ipeds_programs_unique_id", unique: true
  end

  create_table "ipeds_stem_cipcodes", force: :cascade do |t|
    t.string "cip_code_two_digit_series"
    t.string "cip_code_2020"
    t.text "cip_code_title"
    t.index ["cip_code_2020"], name: "iped_stem_cipcodes_unique_id", unique: true
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
    t.datetime "usage_when", precision: nil
    t.string "usage_time"
    t.datetime "usage_other_time", precision: nil
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

  create_table "library_staff_census", force: :cascade do |t|
    t.string "employment_status"
    t.datetime "employment_status_date", precision: nil
    t.string "position_id"
    t.integer "penn_id"
    t.integer "workday_id"
    t.datetime "hire_date", precision: nil
    t.datetime "occupant_from_date", precision: nil
    t.string "legal_last_name"
    t.string "legal_first_name"
    t.decimal "calculated_total_fte"
    t.decimal "primary_percent_effort"
    t.string "position_employee_type"
    t.string "full_part_time"
    t.integer "position_school_ctr"
    t.integer "job_profile_id"
    t.string "job_profile_name"
    t.string "primary_business_title"
    t.string "exempt_job_flag"
    t.string "job_family_id"
    t.string "worker_location"
    t.integer "manager_penn_id"
    t.string "job_family_group_name"
    t.string "job_family_name"
    t.string "primary_email_address_work"
    t.string "supervisory_org_name"
    t.integer "position_penn_cost_center"
    t.string "position_cost_center_desc"
    t.string "org_short_name"
    t.index ["penn_id"], name: "library_staff_census_penn_id"
    t.index ["position_id"], name: "library_staff_census_position_id"
    t.index ["workday_id"], name: "library_staff_census_workday_id"
  end

  create_table "log_job_execution_steps", force: :cascade do |t|
    t.bigint "job_execution_id", null: false
    t.string "step_name", null: false
    t.json "step_yml", null: false
    t.datetime "started_at", precision: nil, null: false
    t.datetime "status_set_at", precision: nil, null: false
    t.string "status", null: false
    t.text "log_text"
    t.index ["job_execution_id"], name: "index_log_job_execution_steps_on_job_execution_id"
  end

  create_table "log_job_executions", force: :cascade do |t|
    t.string "source_name", null: false
    t.string "job_type", null: false
    t.string "mac_address"
    t.json "global_yml", null: false
    t.datetime "started_at", precision: nil, null: false
    t.datetime "status_set_at", precision: nil, null: false
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
    t.datetime "last_run_at", precision: nil
    t.string "last_error_message"
    t.string "output_file_name"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
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
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["report_query_id"], name: "index_report_query_join_clauses_on_report_query_id"
  end

  create_table "report_template_join_clauses", force: :cascade do |t|
    t.string "keyword"
    t.string "table"
    t.string "on_keys"
    t.bigint "report_template_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
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
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "full_sql"
  end

  create_table "reshare_borrowing_turnarounds", force: :cascade do |t|
    t.string "borrower"
    t.string "request_id"
    t.datetime "request_date", precision: nil
    t.datetime "shipped_date", precision: nil
    t.datetime "received_date", precision: nil
    t.decimal "time_to_ship"
    t.decimal "time_to_receipt"
    t.decimal "total_time"
    t.integer "fiscal_year"
    t.index ["borrower", "request_id"], name: "borrowing_turnaround_index", unique: true
  end

  create_table "reshare_directory_entries", force: :cascade do |t|
    t.string "origin"
    t.string "de_id"
    t.bigint "version"
    t.string "de_slug"
    t.string "de_name"
    t.string "de_status_fk"
    t.string "de_parent"
    t.string "de_lms_location_code"
    t.datetime "last_updated", precision: nil
    t.index ["origin", "de_id"], name: "index_reshare_directory_entries_on_origin_and_de_id", unique: true
  end

  create_table "reshare_host_lms_locations", force: :cascade do |t|
    t.string "hll_id"
    t.string "origin"
    t.datetime "hll_date_created", precision: nil
    t.datetime "hll_last_updated", precision: nil
    t.integer "hll_version"
    t.string "hll_code"
    t.string "hll_name"
    t.integer "hll_supply_preference"
    t.string "hll_corresponding_de"
    t.boolean "hll_hidden"
    t.index ["hll_id"], name: "reshare_location_index", unique: true
  end

  create_table "reshare_host_lms_shelving_locations", force: :cascade do |t|
    t.string "hlsl_id"
    t.string "origin"
    t.datetime "hlsl_date_created", precision: nil
    t.datetime "hlsl_last_updated", precision: nil
    t.integer "hlsl_version"
    t.string "hlsl_code"
    t.string "hlsl_name"
    t.integer "hlsl_supply_preference"
    t.boolean "hlsl_hidden"
    t.index ["hlsl_id"], name: "reshare_shelving_location_index", unique: true
  end

  create_table "reshare_lending_turnarounds", force: :cascade do |t|
    t.string "lender"
    t.string "request_id"
    t.datetime "request_date", precision: nil
    t.datetime "filled_date", precision: nil
    t.datetime "shipped_date", precision: nil
    t.datetime "received_date", precision: nil
    t.decimal "time_to_fill"
    t.decimal "time_to_ship"
    t.decimal "time_to_receipt"
    t.decimal "total_time"
    t.integer "fiscal_year"
    t.index ["lender", "request_id"], name: "lending_turnaround_index", unique: true
  end

  create_table "reshare_patron_request_audits", force: :cascade do |t|
    t.datetime "last_updated", precision: nil
    t.string "origin"
    t.string "pra_id"
    t.string "pra_version"
    t.datetime "pra_date_created", precision: nil
    t.string "pra_patron_request_fk"
    t.string "pra_from_status_fk"
    t.string "pra_to_status_fk"
    t.string "pra_message"
    t.index ["pra_id"], name: "index_reshare_patron_request_audits_on_pra_id", unique: true
  end

  create_table "reshare_patron_request_rota", force: :cascade do |t|
    t.datetime "last_updated", precision: nil
    t.string "origin"
    t.string "prr_id"
    t.string "prr_version"
    t.datetime "prr_date_created", precision: nil
    t.datetime "prr_last_updated", precision: nil
    t.integer "prr_rota_position"
    t.string "prr_directory_id_fk"
    t.string "prr_patron_request_fk"
    t.string "prr_state_fk"
    t.string "prr_peer_symbol_fk"
    t.integer "prr_lb_score"
    t.string "prr_lb_reason"
    t.index ["prr_id"], name: "index_reshare_patron_request_rota_on_prr_id", unique: true
  end

  create_table "reshare_patron_requests", force: :cascade do |t|
    t.string "pr_id"
    t.bigint "pr_version"
    t.datetime "pr_date_created", precision: nil
    t.string "pr_pub_date"
    t.datetime "last_updated", precision: nil
    t.string "origin"
    t.string "pr_hrid"
    t.string "pr_patron_type"
    t.string "pr_resolved_req_inst_symbol_fk"
    t.string "pr_resolved_pickup_location_fk"
    t.string "pr_pickup_location_slug"
    t.string "pr_resolved_sup_inst_symbol_fk"
    t.string "pr_pick_location_fk"
    t.string "pr_pick_shelving_location"
    t.string "pr_title"
    t.string "pr_local_call_number"
    t.string "pr_selected_item_barcode"
    t.string "pr_oclc_number"
    t.string "pr_publisher"
    t.string "pr_place_of_pub"
    t.string "pr_bib_record"
    t.string "pr_state_fk"
    t.integer "pr_rota_position"
    t.boolean "pr_is_requester"
    t.datetime "pr_due_date_from_lms", precision: nil
    t.datetime "pr_parsed_due_date_lms", precision: nil
    t.datetime "pr_due_date_rs", precision: nil
    t.datetime "pr_parsed_due_date_rs", precision: nil
    t.boolean "pr_overdue"
    t.string "pr_pick_shelving_location_fk"
    t.string "pr_patron_identifier"
    t.index ["pr_id"], name: "index_reshare_patron_requests_on_pr_id", unique: true
  end

  create_table "reshare_status", force: :cascade do |t|
    t.datetime "last_updated", precision: nil
    t.string "origin"
    t.string "st_id"
    t.string "st_version"
    t.string "st_code"
    t.index ["st_id"], name: "index_reshare_status_on_st_id", unique: true
  end

  create_table "reshare_symbols", force: :cascade do |t|
    t.datetime "last_updated", precision: nil
    t.string "origin"
    t.string "sym_id"
    t.string "sym_version"
    t.string "sym_owner_fk"
    t.string "sym_symbol"
    t.index ["sym_id"], name: "index_reshare_symbols_on_sym_id", unique: true
  end

  create_table "reshare_transactions", force: :cascade do |t|
    t.string "borrower"
    t.string "lender"
    t.string "request_id"
    t.string "borrower_id"
    t.string "lender_id"
    t.datetime "date_created", precision: nil
    t.datetime "borrower_last_updated", precision: nil
    t.datetime "lender_last_updated", precision: nil
    t.string "borrower_status"
    t.string "lender_status"
    t.string "title"
    t.string "publication_date"
    t.string "place_of_publication"
    t.string "publisher"
    t.string "call_number"
    t.string "oclc_number"
    t.string "barcode"
    t.string "pick_location"
    t.string "shelving_location"
    t.string "pickup_location"
    t.integer "fiscal_year"
    t.index ["borrower_id", "lender_id"], name: "transaction_index", unique: true
  end

  create_table "ss_libanswers_queues", force: :cascade do |t|
    t.integer "queue_id"
    t.string "name"
    t.string "email_address"
    t.integer "number_of_tickets", default: 0
    t.datetime "last_modified"
    t.index ["queue_id"], name: "ss_libanswers_queue_id", unique: true
  end

  create_table "ss_libanswers_tickets", force: :cascade do |t|
    t.integer "ticket_id"
    t.integer "queue_id"
    t.datetime "asked_on"
    t.text "question"
    t.text "details"
    t.string "owner"
    t.string "source"
    t.string "status"
    t.string "name"
    t.string "email"
    t.datetime "last_updated"
    t.string "tags"
    t.integer "interactions"
    t.interval "time_to_first_reply"
    t.interval "time_to_close"
    t.string "statistical_category_1"
    t.string "statistical_category_2"
    t.string "statistical_category_3"
    t.string "statistical_category_4"
    t.string "statistical_category_5"
    t.string "user_group", default: "Unknown"
    t.string "school", default: "Unknown"
    t.string "penn_id"
    t.string "pennkey"
    t.index ["ticket_id"], name: "ss_libanswers_ticket_id", unique: true
  end

  create_table "ss_libcal_answers", force: :cascade do |t|
    t.integer "staff_id"
    t.integer "appointment_id"
    t.text "question_id"
    t.string "answer"
    t.index ["appointment_id", "question_id"], name: "ss_libcal_answers_id", unique: true
  end

  create_table "ss_libcal_appointments", force: :cascade do |t|
    t.integer "appointment_id"
    t.date "from_date"
    t.date "to_date"
    t.string "patron_first_name"
    t.string "patron_last_name"
    t.string "patron_email"
    t.integer "staff_id"
    t.string "location"
    t.integer "location_id"
    t.string "group"
    t.integer "group_id"
    t.integer "category_id"
    t.string "directions"
    t.boolean "cancelled"
    t.json "answers"
    t.date "downloaded_at"
    t.index ["appointment_id"], name: "ss_libcal_appointments_id", unique: true
    t.index ["downloaded_at"], name: "ss_libcal_appointments_downloaded_at"
    t.index ["from_date"], name: "ss_libcal_appointments_from_date"
    t.index ["group"], name: "ss_libcal_appointments_group"
    t.index ["location"], name: "ss_libcal_appointments_location"
    t.index ["staff_id"], name: "ss_libcal_appointments_staff_id"
  end

  create_table "ss_libcal_questions", force: :cascade do |t|
    t.integer "question_id"
    t.string "label"
    t.string "answer_type"
    t.boolean "required"
    t.json "options"
    t.index ["question_id"], name: "ss_libcal_questions_id", unique: true
  end

  create_table "ss_libcal_space_answers", force: :cascade do |t|
    t.integer "booking_id"
    t.string "question_key"
    t.string "answer"
    t.index ["booking_id", "question_key"], name: "ss_libcal_space_answer_id", unique: true
  end

  create_table "ss_libcal_space_bookings", force: :cascade do |t|
    t.string "booking_key"
    t.integer "booking_id"
    t.integer "location_id"
    t.string "location_name"
    t.integer "category_id"
    t.string "category_name"
    t.integer "item_id"
    t.string "item_name"
    t.datetime "from_date"
    t.datetime "to_date"
    t.datetime "created"
    t.string "status"
    t.datetime "cancelled"
    t.json "event"
    t.string "nickname"
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "account"
    t.string "statistical_category_1"
    t.string "statistical_category_2"
    t.string "statistical_category_3"
    t.string "statistical_category_4"
    t.string "statistical_category_5"
    t.string "user_group"
    t.string "school"
    t.string "penn_id"
    t.string "pennkey"
    t.json "answers"
    t.datetime "downloaded_at"
    t.index ["booking_id"], name: "ss_libcal_space_booking_id", unique: true
  end

  create_table "ss_libcal_space_forms", force: :cascade do |t|
    t.integer "form_id"
    t.string "name"
    t.json "fields"
    t.index ["form_id"], name: "ss_libcal_space_form_id", unique: true
  end

  create_table "ss_libcal_space_locations", force: :cascade do |t|
    t.integer "location_id"
    t.string "location_name"
    t.boolean "public"
    t.integer "form_id"
    t.index ["location_id"], name: "ss_libcal_space_location_id", unique: true
  end

  create_table "ss_libcal_space_questions", force: :cascade do |t|
    t.integer "form_id"
    t.integer "question_id"
    t.string "question_key"
    t.string "question_type"
    t.boolean "required"
    t.string "label"
    t.json "options"
    t.index ["form_id", "question_key"], name: "ss_libcal_space_question_id", unique: true
  end

  create_table "ss_libcal_users", force: :cascade do |t|
    t.integer "staff_id"
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.index ["staff_id"], name: "ss_libcal_users_id", unique: true
  end

  create_table "upenn_alma_demographics", force: :cascade do |t|
    t.string "pennkey", limit: 8, null: false
    t.string "status"
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

  create_table "upenn_enrollments", force: :cascade do |t|
    t.string "user"
    t.string "school"
    t.integer "value"
    t.integer "fiscal_year"
    t.string "user_parent"
    t.string "school_parent"
  end

  create_table "user_role_sections", force: :cascade do |t|
    t.bigint "user_role_id", null: false
    t.string "section", null: false
    t.string "access_level", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["user_role_id"], name: "index_user_role_sections_on_user_role_id"
  end

  create_table "user_roles", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "admin_users", "user_roles"
  add_foreign_key "file_upload_import_logs", "file_upload_imports"
  add_foreign_key "user_role_sections", "user_roles"
end

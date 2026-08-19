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

ActiveRecord::Schema[8.1].define(version: 2026_08_12_234514) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"
  enable_extension "pgstattuple"

  create_table "active_admin_comments", force: :cascade do |t|
    t.bigint "author_id"
    t.string "author_type"
    t.text "body"
    t.datetime "created_at", precision: nil, null: false
    t.string "namespace"
    t.bigint "resource_id"
    t.string "resource_type"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource"
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", precision: nil, null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "admin_users", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.datetime "current_sign_in_at"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "first_name"
    t.string "last_name"
    t.datetime "last_sign_in_at"
    t.datetime "remember_created_at", precision: nil
    t.datetime "reset_password_sent_at", precision: nil
    t.string "reset_password_token"
    t.integer "sign_in_count", default: 0, null: false
    t.boolean "super_admin", default: false, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "user_role_id"
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "alma_circulations", force: :cascade do |t|
    t.string "author"
    t.string "barcode"
    t.string "bibliographic_material_type"
    t.string "bibliographic_resource_type"
    t.string "classification_code"
    t.string "dewey_group1"
    t.string "dewey_group2"
    t.string "dewey_group3"
    t.string "dewey_number"
    t.date "due_date"
    t.string "first_name"
    t.string "isbn"
    t.string "isbn_normalized"
    t.string "issn"
    t.string "issn_normalized"
    t.date "item_creation"
    t.decimal "item_loan_id"
    t.string "last_name"
    t.date "last_status_update"
    t.string "lc_group1"
    t.string "lc_group2"
    t.string "lc_group3"
    t.string "lc_group4"
    t.string "lc_group5"
    t.string "library_name"
    t.date "loan_date"
    t.decimal "loan_fiscal_year"
    t.string "loan_status"
    t.decimal "loan_year"
    t.string "location_name"
    t.string "mms_id"
    t.string "oclc_control_number_019"
    t.string "oclc_control_number_035a"
    t.string "oclc_control_number_035az"
    t.string "oclc_control_number_035z"
    t.date "original_due_date"
    t.string "penn_id_number"
    t.string "permanent_call_number"
    t.string "physical_item_id"
    t.string "physical_item_material_type"
    t.string "policy_name"
    t.string "process_status"
    t.decimal "renewals"
    t.date "return_date"
    t.string "school"
    t.string "statistical_category_1"
    t.string "statistical_category_2"
    t.string "statistical_category_3"
    t.string "statistical_category_4"
    t.string "statistical_category_5"
    t.string "title"
    t.string "title_normalized"
    t.string "user_group"
    t.index ["bibliographic_material_type"], name: "alma_circulations_bibliographic_material_type"
    t.index ["bibliographic_resource_type"], name: "alma_circulations_bibliographic_resource_type"
    t.index ["item_loan_id"], name: "alma_circulations_item_loan_id", unique: true
    t.index ["last_status_update"], name: "alma_circulations_last_status_update"
    t.index ["library_name"], name: "alma_circulations_library_name"
    t.index ["loan_status"], name: "alma_circulations_loan_status"
    t.index ["location_name"], name: "alma_circulations_location_name"
    t.index ["penn_id_number"], name: "index_alma_circulations_on_penn_id_number"
    t.index ["physical_item_material_type"], name: "alma_circulations_physical_item_material_type"
    t.index ["process_status"], name: "alma_circulations_process_status"
    t.index ["school"], name: "alma_circulations_school"
    t.index ["user_group"], name: "alma_circulations_user_group"
  end

  create_table "bd_reshare_borrowing_turnarounds", force: :cascade do |t|
    t.string "borrower"
    t.integer "fiscal_year"
    t.datetime "received_date", precision: nil
    t.datetime "request_date", precision: nil
    t.string "request_id"
    t.datetime "shipped_date", precision: nil
    t.decimal "time_to_receipt"
    t.decimal "time_to_ship"
    t.decimal "total_time"
    t.index ["borrower", "request_id"], name: "bd_borrowing_turnaround_index", unique: true
  end

  create_table "bd_reshare_directory_entries", force: :cascade do |t|
    t.string "de_id"
    t.string "de_lms_location_code"
    t.string "de_name"
    t.string "de_parent"
    t.string "de_slug"
    t.string "de_status_fk"
    t.datetime "last_updated", precision: nil
    t.string "origin"
    t.bigint "version"
    t.index ["origin", "de_id"], name: "bd_directory_entry_index", unique: true
  end

  create_table "bd_reshare_host_lms_locations", force: :cascade do |t|
    t.string "hll_code"
    t.string "hll_corresponding_de"
    t.datetime "hll_date_created", precision: nil
    t.boolean "hll_hidden"
    t.string "hll_id"
    t.datetime "hll_last_updated", precision: nil
    t.string "hll_name"
    t.integer "hll_supply_preference"
    t.integer "hll_version"
    t.string "origin"
    t.index ["hll_id"], name: "bd_reshare_location_index", unique: true
  end

  create_table "bd_reshare_host_lms_shelving_locations", force: :cascade do |t|
    t.string "hlsl_code"
    t.datetime "hlsl_date_created", precision: nil
    t.boolean "hlsl_hidden"
    t.string "hlsl_id"
    t.datetime "hlsl_last_updated", precision: nil
    t.string "hlsl_name"
    t.integer "hlsl_supply_preference"
    t.integer "hlsl_version"
    t.string "origin"
    t.index ["hlsl_id"], name: "bd_reshare_shelving_location_index", unique: true
  end

  create_table "bd_reshare_lending_turnarounds", force: :cascade do |t|
    t.datetime "filled_date", precision: nil
    t.integer "fiscal_year"
    t.string "lender"
    t.datetime "received_date", precision: nil
    t.datetime "request_date", precision: nil
    t.string "request_id"
    t.datetime "shipped_date", precision: nil
    t.decimal "time_to_fill"
    t.decimal "time_to_receipt"
    t.decimal "time_to_ship"
    t.decimal "total_time"
    t.index ["lender", "request_id"], name: "bd_lending_turnaround_index", unique: true
  end

  create_table "bd_reshare_patron_request_audits", force: :cascade do |t|
    t.datetime "last_updated", precision: nil
    t.string "origin"
    t.datetime "pra_date_created", precision: nil
    t.string "pra_from_status_fk"
    t.string "pra_id"
    t.string "pra_message"
    t.string "pra_patron_request_fk"
    t.string "pra_to_status_fk"
    t.string "pra_version"
    t.index ["pra_id"], name: "bd_patron_request_audit_index", unique: true
  end

  create_table "bd_reshare_patron_request_rota", force: :cascade do |t|
    t.datetime "last_updated", precision: nil
    t.string "origin"
    t.datetime "prr_date_created", precision: nil
    t.string "prr_directory_id_fk"
    t.string "prr_id"
    t.datetime "prr_last_updated", precision: nil
    t.string "prr_lb_reason"
    t.integer "prr_lb_score"
    t.string "prr_patron_request_fk"
    t.string "prr_peer_symbol_fk"
    t.integer "prr_rota_position"
    t.string "prr_state_fk"
    t.string "prr_version"
    t.index ["prr_id"], name: "bd_patron_request_rota_index", unique: true
  end

  create_table "bd_reshare_patron_requests", force: :cascade do |t|
    t.datetime "last_updated", precision: nil
    t.string "origin"
    t.string "pr_bib_record"
    t.datetime "pr_date_created", precision: nil
    t.datetime "pr_due_date_from_lms", precision: nil
    t.datetime "pr_due_date_rs", precision: nil
    t.string "pr_hrid"
    t.string "pr_id"
    t.boolean "pr_is_requester"
    t.string "pr_local_call_number"
    t.string "pr_oclc_number"
    t.boolean "pr_overdue"
    t.datetime "pr_parsed_due_date_lms", precision: nil
    t.datetime "pr_parsed_due_date_rs", precision: nil
    t.string "pr_patron_identifier"
    t.string "pr_patron_type"
    t.string "pr_pick_location_fk"
    t.string "pr_pick_shelving_location"
    t.string "pr_pick_shelving_location_fk"
    t.string "pr_pickup_location_slug"
    t.string "pr_place_of_pub"
    t.string "pr_pub_date"
    t.string "pr_publisher"
    t.string "pr_resolved_pickup_location_fk"
    t.string "pr_resolved_req_inst_symbol_fk"
    t.string "pr_resolved_sup_inst_symbol_fk"
    t.integer "pr_rota_position"
    t.string "pr_selected_item_barcode"
    t.string "pr_state_fk"
    t.string "pr_title"
    t.bigint "pr_version"
    t.index ["pr_id"], name: "bd_patron_requests_index", unique: true
  end

  create_table "bd_reshare_status", force: :cascade do |t|
    t.datetime "last_updated", precision: nil
    t.string "origin"
    t.string "st_code"
    t.string "st_id"
    t.string "st_version"
    t.index ["st_id"], name: "bd_status_index", unique: true
  end

  create_table "bd_reshare_symbols", force: :cascade do |t|
    t.datetime "last_updated", precision: nil
    t.string "origin"
    t.string "sym_id"
    t.string "sym_owner_fk"
    t.string "sym_symbol"
    t.string "sym_version"
    t.index ["sym_id"], name: "bd_symbols_index", unique: true
  end

  create_table "bd_reshare_transactions", force: :cascade do |t|
    t.string "barcode"
    t.string "borrower"
    t.string "borrower_id"
    t.datetime "borrower_last_updated", precision: nil
    t.string "borrower_status"
    t.string "call_number"
    t.datetime "date_created", precision: nil
    t.integer "fiscal_year"
    t.string "lender"
    t.string "lender_id"
    t.datetime "lender_last_updated", precision: nil
    t.string "lender_status"
    t.string "oclc_number"
    t.string "pick_location"
    t.string "pickup_location"
    t.string "place_of_publication"
    t.string "publication_date"
    t.string "publisher"
    t.string "request_id"
    t.string "shelving_location"
    t.string "title"
    t.index ["borrower_id", "lender_id"], name: "bd_transaction_index", unique: true
  end

  create_table "borrowdirect_bibliographies", force: :cascade do |t|
    t.string "author", limit: 300
    t.integer "borrower"
    t.string "call_number", limit: 256
    t.string "edition", limit: 24
    t.boolean "is_legacy", default: false, null: false
    t.string "isbn", limit: 24
    t.string "isbn_2", limit: 24
    t.string "lccn", limit: 50
    t.integer "lender"
    t.string "local_item_found", limit: 1
    t.bigint "oclc"
    t.string "oclc_text", limit: 25
    t.string "patron_type", limit: 1
    t.string "pickup_location", limit: 64
    t.datetime "process_date", precision: nil
    t.string "publication_place", limit: 256
    t.string "publication_year", limit: 4
    t.string "publisher", limit: 256
    t.datetime "request_date", precision: nil
    t.text "request_number"
    t.string "supplier_code", limit: 20
    t.string "title", limit: 400
    t.index ["borrower", "lender", "request_number", "patron_type"], name: "borrowdirect_bibliographies_composite_idx"
    t.index ["borrower"], name: "index_borrowdirect_bibliographies_on_borrower"
    t.index ["call_number"], name: "index_borrowdirect_bibliographies_on_call_number", using: :hash
    t.index ["lender"], name: "index_borrowdirect_bibliographies_on_lender"
    t.index ["patron_type"], name: "index_borrowdirect_bibliographies_on_patron_type"
    t.index ["request_number"], name: "index_borrowdirect_bibliographies_on_request_number"
    t.index ["supplier_code"], name: "index_borrowdirect_bibliographies_on_supplier_code"
  end

  create_table "borrowdirect_call_numbers", force: :cascade do |t|
    t.string "call_number", limit: 256
    t.integer "holdings_seq"
    t.boolean "is_legacy", default: false, null: false
    t.datetime "process_date", precision: nil
    t.string "request_number", limit: 12
    t.string "supplier_code", limit: 20
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
    t.string "institution_name", limit: 100
    t.integer "library_id", null: false
    t.string "library_symbol", limit: 25, null: false
    t.string "prime_post_zipcode", limit: 16
    t.decimal "weighting_factor", precision: 5, scale: 2
    t.index ["library_id"], name: "index_borrowdirect_institutions_on_library_id"
  end

  create_table "borrowdirect_min_ship_dates", force: :cascade do |t|
    t.boolean "is_legacy", default: false, null: false
    t.datetime "min_ship_date", precision: nil, null: false
    t.string "request_number", limit: 12, null: false
    t.index ["request_number"], name: "index_borrowdirect_min_ship_dates_on_request_number"
  end

  create_table "borrowdirect_patron_types", force: :cascade do |t|
    t.boolean "is_legacy", default: false, null: false
    t.string "patron_type", limit: 1, null: false
    t.string "patron_type_desc", limit: 50
    t.index ["patron_type"], name: "index_borrowdirect_patron_types_on_patron_type"
  end

  create_table "borrowdirect_print_dates", force: :cascade do |t|
    t.boolean "is_legacy", default: false, null: false
    t.integer "library_id"
    t.string "note", limit: 256
    t.datetime "print_date", precision: nil
    t.datetime "process_date", precision: nil
    t.string "request_number", limit: 12
    t.index ["request_number"], name: "index_borrowdirect_print_dates_on_request_number"
  end

  create_table "borrowdirect_ship_dates", force: :cascade do |t|
    t.string "exception_code", limit: 3
    t.boolean "is_legacy", default: false, null: false
    t.datetime "process_date", precision: nil
    t.text "request_number"
    t.datetime "ship_date", precision: nil, null: false
    t.index ["exception_code"], name: "index_borrowdirect_ship_dates_on_exception_code"
    t.index ["request_number", "exception_code"], name: "borrowdirect_ship_dates_composite_idx"
    t.index ["request_number"], name: "index_borrowdirect_ship_dates_on_request_number"
  end

  create_table "caiasoft_accession_info", force: :cascade do |t|
    t.datetime "accession_date"
    t.string "accession_date_month"
    t.string "accession_date_year"
    t.string "accession_type"
    t.string "barcode"
    t.string "bib_id"
    t.string "call_number"
    t.string "collection"
    t.datetime "created_at", null: false
    t.string "fiscal_year"
    t.string "item_id"
    t.string "material"
    t.string "pid"
    t.string "title"
    t.datetime "updated_at", null: false
    t.string "volume"
    t.index ["barcode", "accession_date", "accession_type"], name: "caiasoft_accession_info_unique", unique: true
  end

  create_table "caiasoft_circulation_metrics", force: :cascade do |t|
    t.string "api_feed"
    t.string "circulation_stop"
    t.datetime "created_at", null: false
    t.string "details"
    t.string "item_call_number"
    t.string "item_collection"
    t.string "item_retrieved"
    t.string "item_title"
    t.string "job"
    t.string "job_type"
    t.integer "page_count"
    t.string "request_id"
    t.string "requestor"
    t.datetime "retrieval_date"
    t.string "retrieval_date_month"
    t.string "retrieval_date_year"
    t.string "stop_location"
    t.datetime "updated_at", null: false
    t.index ["item_retrieved", "request_id", "job"], name: "caiasoft_circulation_metrics_unique", unique: true
  end

  create_table "caiasoft_deaccession_info", force: :cascade do |t|
    t.string "barcode"
    t.string "bib_id"
    t.string "collection"
    t.datetime "created_at", null: false
    t.datetime "deaccession_date"
    t.string "deaccession_date_month"
    t.string "deaccession_date_year"
    t.string "deaccession_type"
    t.string "fiscal_year"
    t.string "item_id"
    t.string "job"
    t.string "pid"
    t.string "request_id"
    t.string "requestor"
    t.string "status_update"
    t.datetime "updated_at", null: false
    t.index ["barcode", "job"], name: "caiasoft_deaccession_info_unique", unique: true
  end

  create_table "cr_ares_course_users", force: :cascade do |t|
    t.integer "course_id"
    t.string "user_type"
    t.string "username"
    t.index ["course_id"], name: "cr_ares_course_users_course_id"
    t.index ["user_type"], name: "cr_ares_course_users_user_type"
  end

  create_table "cr_ares_courses", force: :cascade do |t|
    t.string "course_code"
    t.decimal "course_enrollment"
    t.integer "course_id"
    t.string "default_pickup_site"
    t.string "department"
    t.string "external_course_id"
    t.string "instructor"
    t.string "name"
    t.string "registrar_course_id"
    t.string "semester"
    t.datetime "start_date", precision: nil
    t.datetime "stop_date", precision: nil
    t.index ["course_id"], name: "cr_ares_courses_course_id"
    t.index ["semester"], name: "cr_ares_courses_semester"
  end

  create_table "cr_ares_custom_drop_downs", force: :cascade do |t|
    t.string "group_name"
    t.string "label_name"
    t.string "label_value"
  end

  create_table "cr_ares_item_history", force: :cascade do |t|
    t.datetime "date_time", precision: nil
    t.string "entry"
    t.integer "item_id"
    t.string "username"
    t.index ["item_id"], name: "cr_ares_item_history_item_id"
    t.index ["username"], name: "cr_ares_item_history_username"
  end

  create_table "cr_ares_item_trackings", force: :cascade do |t|
    t.integer "item_id"
    t.string "status"
    t.datetime "tracking_date_time", precision: nil
    t.string "username"
    t.index ["item_id"], name: "cr_ares_item_trackings_item_id"
    t.index ["username"], name: "cr_ares_item_trackings_username"
  end

  create_table "cr_ares_items", force: :cascade do |t|
    t.datetime "active_date", precision: nil
    t.boolean "ares_document"
    t.string "article_title"
    t.string "author"
    t.string "callnumber"
    t.boolean "copyright_obtained"
    t.boolean "copyright_required"
    t.integer "course_id"
    t.string "current_status"
    t.datetime "current_status_date", precision: nil
    t.text "description"
    t.boolean "digital_item"
    t.string "document_type"
    t.string "doi"
    t.string "edition"
    t.string "editor"
    t.string "esp_number"
    t.datetime "inactive_date", precision: nil
    t.string "issue"
    t.string "isxn"
    t.string "item_barcode"
    t.string "item_format"
    t.integer "item_id"
    t.string "item_type"
    t.string "journal_month"
    t.string "journal_year"
    t.string "location"
    t.string "needed_by"
    t.string "pickup_location"
    t.string "processing_location"
    t.boolean "proxy"
    t.string "pub_date"
    t.string "pub_place"
    t.string "publisher"
    t.text "reason_for_cancellation"
    t.string "shelf_location"
    t.string "title"
    t.string "volume"
    t.index ["course_id"], name: "cr_ares_items_course_id"
    t.index ["item_id"], name: "cr_ares_items_item_id"
  end

  create_table "cr_ares_semesters", force: :cascade do |t|
    t.datetime "end_date", precision: nil
    t.string "semester"
    t.datetime "start_date", precision: nil
    t.index ["semester"], name: "cr_ares_semesters_semester"
  end

  create_table "cr_ares_sites", force: :cascade do |t|
    t.boolean "available_for_pickup"
    t.boolean "available_for_processing"
    t.string "default_processing_site"
    t.string "site_code"
    t.string "site_name"
  end

  create_table "cr_ares_users", force: :cascade do |t|
    t.string "auth_method"
    t.string "cleared"
    t.boolean "course_email_default"
    t.string "department"
    t.string "e_mail_address"
    t.datetime "expiration_date", precision: nil
    t.string "external_user_id"
    t.string "first_name"
    t.datetime "last_login_date", precision: nil
    t.string "last_name"
    t.string "library_id"
    t.string "status"
    t.boolean "trusted"
    t.string "user_type"
    t.string "username"
    t.index ["user_type"], name: "cr_ares_users_user_type"
    t.index ["username"], name: "cr_ares_users_username"
  end

  create_table "cr_legacy_courses", force: :cascade do |t|
    t.string "course_code"
    t.integer "course_id"
    t.string "default_pickup_site"
    t.string "department"
    t.string "instructor_department"
    t.string "instructor_first_name"
    t.string "instructor_last_name"
    t.integer "instructor_penn_id"
    t.string "instructor_pennkey"
    t.string "name"
    t.string "registrar_course_id"
    t.string "semester"
    t.index ["course_id"], name: "cr_legacy_courses_course_id"
    t.index ["semester"], name: "cr_legacy_courses_semester"
  end

  create_table "cr_legacy_items", force: :cascade do |t|
    t.string "author"
    t.string "callnumber"
    t.integer "course_id"
    t.string "document_type"
    t.string "edition"
    t.string "isxn"
    t.string "item_barcode"
    t.string "item_format"
    t.string "item_id"
    t.string "location"
    t.string "processing_location"
    t.string "pub_place"
    t.string "publisher"
    t.string "title"
    t.string "volume"
    t.index ["course_id"], name: "cr_legacy_items_course_id"
    t.index ["item_id"], name: "cr_legacy_items_item_id"
  end

  create_table "cr_leganto_citations", force: :cascade do |t|
    t.string "author"
    t.string "book_chapter_title"
    t.bigint "citation_id"
    t.integer "citation_order"
    t.string "citation_origin"
    t.string "citation_source"
    t.string "citation_type"
    t.string "citation_uploaded_file"
    t.string "copyrights_status"
    t.string "created_by"
    t.datetime "creation_date"
    t.string "external_source_id"
    t.boolean "has_electronic"
    t.boolean "has_physical"
    t.string "isbn"
    t.string "issn"
    t.string "issue"
    t.string "journal_title"
    t.string "material_type"
    t.datetime "modification_date"
    t.string "publication_year"
    t.string "publisher"
    t.string "resource_type"
    t.string "title"
    t.string "volume"
    t.index ["citation_id"], name: "cr_leganto_items_citation_id", unique: true
  end

  create_table "cr_leganto_course_citations", force: :cascade do |t|
    t.bigint "citation_id"
    t.bigint "course_id"
    t.datetime "modification_date"
    t.bigint "reading_list_id"
    t.index ["citation_id"], name: "cr_leganto_course_citations_citation_id"
    t.index ["course_id", "reading_list_id", "citation_id"], name: "cr_leganto_course_citations_usage_id", unique: true
    t.index ["course_id"], name: "cr_leganto_course_citations_course_id"
  end

  create_table "cr_leganto_courses", force: :cascade do |t|
    t.string "academic_department"
    t.string "course_code"
    t.datetime "course_end_date"
    t.integer "course_enrollment"
    t.bigint "course_id"
    t.string "course_name"
    t.datetime "course_start_date"
    t.string "course_term"
    t.string "course_year"
    t.datetime "creation_date"
    t.datetime "modification_date"
    t.string "processing_department"
    t.index ["course_code"], name: "index_cr_leganto_courses_on_course_code"
    t.index ["course_id"], name: "cr_leganto_courses_course_id", unique: true
  end

  create_table "cr_leganto_reading_lists", force: :cascade do |t|
    t.datetime "creation_date"
    t.string "has_course_association"
    t.datetime "modification_date"
    t.integer "number_of_citations"
    t.string "owner"
    t.string "owner_pennid"
    t.bigint "reading_list_id"
    t.string "status"
    t.date "visible_end_date"
    t.date "visible_start_date"
    t.index ["reading_list_id"], name: "index_cr_leganto_reading_lists_on_reading_list_id", unique: true
  end

  create_table "cr_leganto_usage", force: :cascade do |t|
    t.bigint "citation_id"
    t.integer "citation_views"
    t.bigint "course_id"
    t.date "event_date"
    t.integer "file_views"
    t.integer "files_downloaded"
    t.integer "full_text_views"
    t.string "link_type"
    t.bigint "reading_list_id"
    t.string "student_type"
    t.integer "total_views"
    t.string "user_role"
    t.index ["citation_id"], name: "index_cr_leganto_usage_on_citation_id"
    t.index ["course_id", "citation_id", "reading_list_id", "event_date", "user_role", "student_type", "link_type"], name: "cr_leganto_usage_index", unique: true
    t.index ["course_id"], name: "index_cr_leganto_usage_on_course_id"
    t.index ["event_date"], name: "index_cr_leganto_usage_on_event_date"
    t.index ["reading_list_id"], name: "index_cr_leganto_usage_on_reading_list_id"
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer "attempts", default: 0, null: false
    t.datetime "created_at", precision: nil
    t.datetime "failed_at", precision: nil
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "locked_at", precision: nil
    t.string "locked_by"
    t.integer "priority", default: 0, null: false
    t.string "queue"
    t.datetime "run_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "ezborrow_bibliographies", force: :cascade do |t|
    t.string "author", limit: 300
    t.integer "borrower"
    t.string "call_number", limit: 256
    t.string "edition", limit: 24
    t.boolean "is_legacy", default: false, null: false
    t.string "isbn", limit: 24
    t.string "isbn_2", limit: 24
    t.string "lccn", limit: 32
    t.integer "lender"
    t.string "local_item_found", limit: 1
    t.integer "oclc"
    t.string "patron_id", limit: 20
    t.string "patron_type", limit: 1
    t.string "pickup_location", limit: 64
    t.datetime "process_date", precision: nil
    t.string "publication_date", limit: 255
    t.string "publication_place", limit: 256
    t.string "publication_year", limit: 4
    t.string "publisher", limit: 256
    t.datetime "request_date", precision: nil
    t.string "request_number", limit: 12
    t.string "supplier_code", limit: 20
    t.string "title", limit: 400
  end

  create_table "ezborrow_call_numbers", force: :cascade do |t|
    t.string "call_number", limit: 256
    t.integer "holdings_seq"
    t.boolean "is_legacy", default: false, null: false
    t.datetime "process_date", precision: nil
    t.string "request_number", limit: 12
    t.string "supplier_code", limit: 20
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
    t.string "institution_name", limit: 100
    t.integer "library_id", null: false
    t.string "library_symbol", limit: 25, null: false
    t.string "prime_post_zipcode", limit: 16
    t.decimal "weighting_factor", precision: 5, scale: 2
  end

  create_table "ezborrow_min_ship_dates", force: :cascade do |t|
    t.boolean "is_legacy", default: false, null: false
    t.datetime "min_ship_date", precision: nil, null: false
    t.string "request_number", limit: 12, null: false
  end

  create_table "ezborrow_patron_types", force: :cascade do |t|
    t.boolean "is_legacy", default: false, null: false
    t.string "patron_type", limit: 1, null: false
    t.string "patron_type_desc", limit: 32
  end

  create_table "ezborrow_print_dates", force: :cascade do |t|
    t.boolean "is_legacy", default: false, null: false
    t.integer "library_id"
    t.string "note", limit: 256
    t.datetime "print_date", precision: nil
    t.datetime "process_date", precision: nil
    t.string "request_number", limit: 12
  end

  create_table "ezborrow_ship_dates", force: :cascade do |t|
    t.string "exception_code", limit: 3
    t.boolean "is_legacy", default: false, null: false
    t.datetime "process_date", precision: nil
    t.string "request_number", limit: 12
    t.datetime "ship_date", precision: nil
  end

  create_table "ezpaarse_hourly_usages", force: :cascade do |t|
    t.date "date"
    t.string "day_of_week"
    t.integer "dow_index"
    t.integer "fiscal_year"
    t.integer "hour_of_day"
    t.integer "requests"
    t.integer "sessions"
  end

  create_table "ezpaarse_job_reports", force: :cascade do |t|
    t.date "date"
    t.float "denied_ecs"
    t.float "duplicate_ecs"
    t.float "ecs"
    t.string "filename"
    t.float "ignored"
    t.float "ignored_domains"
    t.float "ignored_hosts"
    t.float "lines_input"
    t.float "off_campus"
    t.float "on_campus"
    t.float "robots_ecs"
    t.float "unknown_domains"
    t.float "unknown_errors"
    t.float "unknown_formats"
    t.float "unordered_ecs"
    t.float "unqualified_ecs"
    t.index ["filename"], name: "ezpaarse_job_report_date", unique: true
  end

  create_table "ezpaarse_jobs", force: :cascade do |t|
    t.string "file_name"
    t.date "log_date"
    t.text "message"
    t.datetime "run_date", precision: nil
  end

  create_table "ezpaarse_logs", force: :cascade do |t|
    t.string "checksum_index"
    t.datetime "datetime", precision: nil
    t.string "doi"
    t.string "domain"
    t.string "geoip_city"
    t.string "geoip_country", limit: 4
    t.float "geoip_latitude"
    t.float "geoip_longitude"
    t.string "geoip_region", limit: 4
    t.string "host"
    t.string "license"
    t.string "login"
    t.string "method", limit: 8
    t.string "mime"
    t.boolean "on_campus"
    t.string "online_identifier"
    t.text "penn_id"
    t.string "platform"
    t.string "platform_name"
    t.string "print_identifier"
    t.string "publication_date"
    t.string "publication_title"
    t.string "referer"
    t.string "resource_name"
    t.string "rtype"
    t.string "school"
    t.string "session_id"
    t.bigint "size"
    t.string "statistical_category_1"
    t.string "statistical_category_2"
    t.string "statistical_category_3"
    t.string "statistical_category_4"
    t.string "statistical_category_5"
    t.string "status", limit: 3
    t.string "subject"
    t.string "title"
    t.string "title_id"
    t.string "type"
    t.string "unitid"
    t.string "url"
    t.text "user_group"
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
    t.string "mime"
    t.string "platform_name"
    t.integer "requests"
    t.string "rtype"
    t.integer "sessions"
  end

  create_table "ezpaarse_user_profiles", force: :cascade do |t|
    t.string "country"
    t.integer "fiscal_year"
    t.integer "requests"
    t.string "school"
    t.integer "sessions"
    t.string "state"
    t.string "user_group"
  end

  create_table "file_upload_import_logs", force: :cascade do |t|
    t.bigint "file_upload_import_id", null: false
    t.datetime "log_datetime", precision: nil, null: false
    t.string "log_text"
    t.integer "sequence", null: false
    t.index ["file_upload_import_id"], name: "index_file_upload_import_logs_on_file_upload_import_id"
  end

  create_table "file_upload_imports", force: :cascade do |t|
    t.string "comments"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "last_attempted_at", precision: nil
    t.integer "n_rows_processed"
    t.string "post_sql_to_execute"
    t.string "status"
    t.string "target_model", null: false
    t.integer "total_rows_to_process"
    t.datetime "updated_at", precision: nil, null: false
    t.datetime "uploaded_at", precision: nil, null: false
    t.integer "uploaded_by_id"
  end

  create_table "ga_ua_daily_reports", force: :cascade do |t|
    t.decimal "avg_session_duration"
    t.decimal "bounce_rate"
    t.integer "bounces"
    t.date "date"
    t.integer "fiscal_year"
    t.integer "new_users"
    t.integer "pageviews"
    t.decimal "pageviews_per_session"
    t.integer "property"
    t.decimal "session_duration"
    t.integer "sessions"
    t.decimal "sessions_per_user"
    t.integer "users"
    t.index ["date"], name: "index_ga_ua_daily_reports_on_date"
    t.index ["fiscal_year"], name: "index_ga_ua_daily_reports_on_fiscal_year"
    t.index ["property", "fiscal_year", "date"], name: "ga_ua_daily_report_id", unique: true
    t.index ["property"], name: "index_ga_ua_daily_reports_on_property"
  end

  create_table "ga_ua_devices", force: :cascade do |t|
    t.decimal "avg_session_duration"
    t.decimal "bounce_rate"
    t.integer "bounces"
    t.string "browser"
    t.date "date"
    t.integer "fiscal_year"
    t.integer "new_users"
    t.string "operating_system"
    t.integer "pageviews"
    t.decimal "pageviews_per_session"
    t.integer "property"
    t.decimal "session_duration"
    t.integer "sessions"
    t.decimal "sessions_per_user"
    t.integer "users"
    t.index ["browser"], name: "index_ga_ua_devices_on_browser"
    t.index ["date"], name: "index_ga_ua_devices_on_date"
    t.index ["fiscal_year"], name: "index_ga_ua_devices_on_fiscal_year"
    t.index ["operating_system"], name: "index_ga_ua_devices_on_operating_system"
    t.index ["property", "fiscal_year", "date", "browser", "operating_system"], name: "ga_ua_device_id", unique: true
    t.index ["property"], name: "index_ga_ua_devices_on_property"
  end

  create_table "ga_ua_locations", force: :cascade do |t|
    t.decimal "avg_session_duration"
    t.decimal "bounce_rate"
    t.integer "bounces"
    t.string "city"
    t.string "continent"
    t.string "country"
    t.string "country_iso_code"
    t.date "date"
    t.integer "fiscal_year"
    t.string "metro"
    t.integer "new_users"
    t.integer "pageviews"
    t.decimal "pageviews_per_session"
    t.integer "property"
    t.string "region"
    t.string "region_iso_code"
    t.decimal "session_duration"
    t.integer "sessions"
    t.decimal "sessions_per_user"
    t.string "sub_continent"
    t.integer "users"
    t.index ["country_iso_code"], name: "index_ga_ua_locations_on_country_iso_code"
    t.index ["date"], name: "index_ga_ua_locations_on_date"
    t.index ["fiscal_year"], name: "index_ga_ua_locations_on_fiscal_year"
    t.index ["property", "fiscal_year", "date", "country_iso_code", "region_iso_code", "region", "metro", "city"], name: "ga_ua_location_id", unique: true
    t.index ["property"], name: "index_ga_ua_locations_on_property"
    t.index ["region_iso_code"], name: "index_ga_ua_locations_on_region_iso_code"
  end

  create_table "ga_ua_pageviews", force: :cascade do |t|
    t.decimal "avg_time_on_page"
    t.decimal "bounce_rate"
    t.integer "bounces"
    t.date "date"
    t.decimal "entrance_rate"
    t.integer "entrances"
    t.decimal "exit_rate"
    t.integer "exits"
    t.integer "fiscal_year"
    t.string "page_path"
    t.integer "pageviews"
    t.integer "property"
    t.decimal "time_on_page"
    t.integer "unique_pageviews"
    t.index ["date"], name: "index_ga_ua_pageviews_on_date"
    t.index ["fiscal_year"], name: "index_ga_ua_pageviews_on_fiscal_year"
    t.index ["page_path"], name: "index_ga_ua_pageviews_on_page_path"
    t.index ["property", "fiscal_year", "date", "page_path"], name: "ga_ua_pageview_id", unique: true
    t.index ["property"], name: "index_ga_ua_pageviews_on_property"
  end

  create_table "ga_ua_properties", force: :cascade do |t|
    t.string "description"
    t.string "name"
    t.integer "property"
    t.string "url"
    t.index ["property"], name: "index_ga_ua_properties_on_property", unique: true
  end

  create_table "ga_ua_sources", force: :cascade do |t|
    t.decimal "avg_session_duration"
    t.decimal "bounce_rate"
    t.integer "bounces"
    t.date "date"
    t.integer "fiscal_year"
    t.integer "new_users"
    t.integer "pageviews"
    t.decimal "pageviews_per_session"
    t.integer "property"
    t.decimal "session_duration"
    t.integer "sessions"
    t.decimal "sessions_per_user"
    t.string "source"
    t.integer "users"
    t.index ["date"], name: "index_ga_ua_sources_on_date"
    t.index ["fiscal_year"], name: "index_ga_ua_sources_on_fiscal_year"
    t.index ["property", "fiscal_year", "date", "source"], name: "ga_ua_source_id", unique: true
    t.index ["property"], name: "index_ga_ua_sources_on_property"
    t.index ["source"], name: "index_ga_ua_sources_on_source"
  end

  create_table "gate_count_card_swipes", force: :cascade do |t|
    t.string "affiliation_desc"
    t.string "card_num"
    t.string "center_desc"
    t.string "dept_desc"
    t.string "door_name"
    t.string "first_name"
    t.string "last_name"
    t.text "pennkey"
    t.string "school"
    t.string "statistical_category_1"
    t.string "statistical_category_2"
    t.string "statistical_category_3"
    t.string "statistical_category_4"
    t.string "statistical_category_5"
    t.datetime "swipe_date", precision: nil
    t.string "usc_desc"
    t.text "user_group"
    t.index ["affiliation_desc"], name: "index_gate_count_card_swipes_on_affiliation_desc"
    t.index ["center_desc"], name: "index_gate_count_card_swipes_on_center_desc"
    t.index ["dept_desc"], name: "index_gate_count_card_swipes_on_dept_desc"
    t.index ["door_name"], name: "index_gate_count_card_swipes_on_door_name"
    t.index ["swipe_date", "door_name", "card_num"], name: "gate_count_card_swipes_uid", unique: true
    t.index ["swipe_date"], name: "index_gate_count_card_swipes_on_swipe_date"
    t.index ["usc_desc"], name: "index_gate_count_card_swipes_on_usc_desc"
  end

  create_table "gate_count_kislak_swipes", force: :cascade do |t|
    t.string "door_name"
    t.integer "fiscal_year"
    t.integer "month"
    t.string "name"
    t.integer "total_swipes"
    t.integer "year"
    t.index ["year", "month", "door_name", "name"], name: "gate_count_kislak_swipe_uid", unique: true
  end

  create_table "gate_count_legacy_biotech_counts", force: :cascade do |t|
    t.integer "fiscal_year"
    t.integer "month"
    t.string "month_name"
    t.integer "value"
    t.integer "year"
    t.index ["year", "month"], name: "index_gate_count_legacy_biotech_counts_on_year_and_month", unique: true
  end

  create_table "geo_data_country_codes", force: :cascade do |t|
    t.string "capital"
    t.string "cldr_display_name"
    t.string "fips"
    t.string "iso3166_1_alpha_3"
    t.string "iso3166_1_numeric"
    t.string "iso3166_alpha_2"
    t.string "marc"
    t.string "region_name"
    t.string "sub_region_name"
    t.string "unterm_english_official"
    t.string "unterm_english_short"
  end

  create_table "geo_data_zip_codes", force: :cascade do |t|
    t.string "latitude"
    t.string "longitude"
    t.string "zip_code"
  end

  create_table "illiad_borrowings", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.bigint "institution_id", null: false
    t.boolean "is_legacy", default: false, null: false
    t.string "request_type", limit: 255, null: false
    t.datetime "transaction_date", precision: nil, null: false
    t.bigint "transaction_number", null: false
    t.string "transaction_status", limit: 255, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["institution_id"], name: "index_illiad_borrowings_on_institution_id"
    t.index ["transaction_number"], name: "index_illiad_borrowings_on_transaction_number"
    t.index ["transaction_status"], name: "index_illiad_borrowings_on_transaction_status"
  end

  create_table "illiad_doc_del_trackings", force: :cascade do |t|
    t.datetime "arrival_date", precision: nil
    t.datetime "completion_date", precision: nil
    t.string "completion_status", limit: 255
    t.datetime "created_at", precision: nil, null: false
    t.bigint "institution_id", null: false
    t.boolean "is_legacy", default: false, null: false
    t.string "request_type", limit: 255, null: false
    t.bigint "transaction_number", null: false
    t.float "turnaround"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["institution_id"], name: "index_illiad_doc_del_trackings_on_institution_id"
  end

  create_table "illiad_doc_dels", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.bigint "institution_id", null: false
    t.boolean "is_legacy", default: false, null: false
    t.string "request_type", limit: 255, null: false
    t.string "status", limit: 255, null: false
    t.datetime "transaction_date", precision: nil, null: false
    t.bigint "transaction_number", null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["institution_id"], name: "index_illiad_doc_dels_on_institution_id"
  end

  create_table "illiad_groups", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.string "group_name", limit: 255, null: false
    t.integer "group_no", null: false
    t.bigint "institution_id", null: false
    t.boolean "is_legacy", default: false, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["institution_id"], name: "index_illiad_groups_on_institution_id"
  end

  create_table "illiad_history_records", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.string "entry", null: false
    t.bigint "institution_id", null: false
    t.boolean "is_legacy", default: false, null: false
    t.datetime "record_datetime", precision: nil, null: false
    t.bigint "transaction_number", null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["institution_id"], name: "index_illiad_history_records_on_institution_id"
  end

  create_table "illiad_lender_groups", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.integer "group_no", null: false
    t.bigint "institution_id", null: false
    t.boolean "is_legacy", default: false, null: false
    t.string "lender_code", limit: 255, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["institution_id"], name: "index_illiad_lender_groups_on_institution_id"
  end

  create_table "illiad_lender_infos", force: :cascade do |t|
    t.string "address", limit: 328
    t.integer "address_number"
    t.string "billing_category", limit: 255
    t.datetime "created_at", precision: nil, null: false
    t.bigint "institution_id", null: false
    t.boolean "is_legacy", default: false, null: false
    t.string "lender_code", limit: 255, null: false
    t.string "library_name", limit: 255
    t.string "nvtgc", limit: 255
    t.datetime "updated_at", precision: nil, null: false
    t.index ["institution_id"], name: "index_illiad_lender_infos_on_institution_id"
  end

  create_table "illiad_lending_trackings", force: :cascade do |t|
    t.datetime "arrival_date", precision: nil
    t.datetime "completion_date", precision: nil
    t.string "completion_status", limit: 255
    t.datetime "created_at", precision: nil, null: false
    t.bigint "institution_id", null: false
    t.boolean "is_legacy", default: false, null: false
    t.string "request_type", limit: 255, null: false
    t.bigint "transaction_number", null: false
    t.float "turnaround"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["institution_id"], name: "index_illiad_lending_trackings_on_institution_id"
  end

  create_table "illiad_lendings", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.bigint "institution_id", null: false
    t.boolean "is_legacy", default: false, null: false
    t.string "request_type", limit: 255, null: false
    t.string "status", limit: 255, null: false
    t.datetime "transaction_date", precision: nil, null: false
    t.bigint "transaction_number", null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["institution_id"], name: "index_illiad_lendings_on_institution_id"
  end

  create_table "illiad_reference_numbers", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.bigint "institution_id", null: false
    t.boolean "is_legacy", default: false, null: false
    t.string "oclc", limit: 255
    t.string "ref_number", limit: 255
    t.string "ref_type", limit: 255
    t.bigint "transaction_number", null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["institution_id"], name: "index_illiad_reference_numbers_on_institution_id"
  end

  create_table "illiad_trackings", force: :cascade do |t|
    t.string "completion_status"
    t.datetime "created_at", precision: nil, null: false
    t.bigint "institution_id", null: false
    t.boolean "is_legacy", default: false, null: false
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
    t.datetime "updated_at", precision: nil, null: false
    t.index ["institution_id"], name: "index_illiad_trackings_on_institution_id"
    t.index ["order_date"], name: "index_illiad_trackings_on_order_date"
  end

  create_table "illiad_transactions", force: :cascade do |t|
    t.string "billing_amount", limit: 255
    t.string "borrower_nvtgc", limit: 255
    t.string "call_number", limit: 255
    t.string "cited_in", limit: 10000
    t.datetime "created_at", precision: nil, null: false
    t.datetime "creation_date", precision: nil
    t.string "esp_number", limit: 255
    t.string "ifm_cost", limit: 255
    t.string "in_process_date", limit: 255
    t.bigint "institution_id", null: false
    t.boolean "is_legacy", default: false, null: false
    t.string "issn", limit: 255
    t.integer "lender_address_number"
    t.string "lender_codes", limit: 255
    t.string "lending_library", limit: 255
    t.string "loan_author", limit: 255
    t.string "loan_date", limit: 255
    t.string "loan_edition", limit: 255
    t.string "loan_location", limit: 255
    t.string "loan_publisher", limit: 255
    t.string "loan_title", limit: 500
    t.string "location", limit: 255
    t.string "original_nvtgc", limit: 255
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
    t.datetime "updated_at", precision: nil, null: false
    t.index ["institution_id"], name: "index_illiad_transactions_on_institution_id"
  end

  create_table "illiad_user_infos", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.string "department", limit: 255
    t.bigint "institution_id", null: false
    t.boolean "is_legacy", default: false, null: false
    t.string "nvtgc", limit: 255
    t.string "status", limit: 255
    t.datetime "updated_at", precision: nil, null: false
    t.index ["institution_id"], name: "index_illiad_user_infos_on_institution_id"
  end

  create_table "institutions", force: :cascade do |t|
    t.string "code", null: false
    t.datetime "created_at", precision: nil, null: false
    t.string "name", null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "zip_code"
  end

  create_table "ipeds_cipcodes", force: :cascade do |t|
    t.text "action"
    t.string "cip_code2010"
    t.string "cip_code2020"
    t.text "cip_title2010"
    t.text "cip_title2020"
    t.string "text_change"
    t.index ["cip_code2010", "cip_code2020"], name: "ipeds_cipcodes_unique_id", unique: true
  end

  create_table "ipeds_completion_schema", force: :cascade do |t|
    t.string "data_type"
    t.integer "fieldwidth"
    t.string "format"
    t.string "imputationvar"
    t.text "var_title"
    t.string "varname"
    t.index ["varname"], name: "ipeds_completion_schema_unique_id", unique: true
  end

  create_table "ipeds_completions", force: :cascade do |t|
    t.integer "awlevel"
    t.integer "c2_morm"
    t.integer "c2_mort"
    t.integer "c2_morw"
    t.integer "caianm"
    t.integer "caiant"
    t.integer "caianw"
    t.integer "casiam"
    t.integer "casiat"
    t.integer "casiaw"
    t.integer "cbkaam"
    t.integer "cbkaat"
    t.integer "cbkaaw"
    t.integer "chispm"
    t.integer "chispt"
    t.integer "chispw"
    t.text "cipcode"
    t.integer "cnhpim"
    t.integer "cnhpit"
    t.integer "cnhpiw"
    t.integer "cnralm"
    t.integer "cnralt"
    t.integer "cnralw"
    t.integer "ctotalm"
    t.integer "ctotalt"
    t.integer "ctotalw"
    t.integer "cunknm"
    t.integer "cunknt"
    t.integer "cunknw"
    t.integer "cwhitm"
    t.integer "cwhitt"
    t.integer "cwhitw"
    t.integer "majornum"
    t.integer "unitid"
    t.integer "year"
    t.index ["year", "unitid", "cipcode", "majornum", "awlevel"], name: "ipeds_completions_unique_id", unique: true
  end

  create_table "ipeds_directories", force: :cascade do |t|
    t.string "act"
    t.text "addr"
    t.text "adminurl"
    t.text "applurl"
    t.text "athurl"
    t.integer "c00_carnegie"
    t.integer "c15_basic"
    t.integer "c18_basic"
    t.integer "c18_enprf"
    t.integer "c18_ipgrd"
    t.integer "c18_ipug"
    t.integer "c18_szset"
    t.integer "c18_ugprf"
    t.integer "c21_basic"
    t.integer "carnegie"
    t.integer "carnegiealf"
    t.integer "carnegieapm"
    t.integer "carnegiegpm"
    t.integer "carnegieic"
    t.integer "carnegiersch"
    t.integer "carnegiesaec"
    t.integer "carnegiesize"
    t.integer "cbsa"
    t.integer "cbsatype"
    t.integer "ccbasic"
    t.text "chfnm"
    t.text "chftitle"
    t.text "city"
    t.text "closedat"
    t.integer "cngdstcd"
    t.integer "control"
    t.integer "countycd"
    t.text "countynm"
    t.integer "csa"
    t.integer "cyactive"
    t.integer "deathyr"
    t.integer "deggrant"
    t.integer "dfrcgid"
    t.integer "dfrcuscg"
    t.text "disaurl"
    t.text "duns"
    t.string "ein"
    t.string "f1_syscod"
    t.text "f1_sysnam"
    t.integer "f1_systyp"
    t.text "faidurl"
    t.integer "fips"
    t.text "gentele"
    t.integer "groffer"
    t.integer "hbcu"
    t.integer "hdegofr1"
    t.integer "hloffer"
    t.integer "hospital"
    t.text "ialias"
    t.integer "iclevel"
    t.integer "instcat"
    t.text "instnm"
    t.integer "instsize"
    t.integer "landgrnt"
    t.float "latitude"
    t.integer "locale"
    t.float "longitud"
    t.integer "medical"
    t.integer "necta"
    t.integer "newid"
    t.text "npricurl"
    t.integer "obereg"
    t.integer "opeflag"
    t.string "opeid"
    t.integer "openpubl"
    t.integer "postsec"
    t.integer "pseflag"
    t.integer "pset4_flg"
    t.integer "rptmth"
    t.integer "sector"
    t.string "stabbr"
    t.integer "tribal"
    t.string "ueis"
    t.integer "ugoffer"
    t.integer "unitid"
    t.text "veturl"
    t.text "webaddr"
    t.string "zip"
    t.index ["unitid"], name: "ipeds_directories_unique_id", unique: true
  end

  create_table "ipeds_directory_schema", force: :cascade do |t|
    t.string "data_type"
    t.integer "fieldwidth"
    t.string "format"
    t.string "imputationvar"
    t.text "var_title"
    t.string "varname"
    t.index ["varname"], name: "ipeds_directory_schema_unique_id", unique: true
  end

  create_table "ipeds_program_schema", force: :cascade do |t|
    t.string "data_type"
    t.integer "fieldwidth"
    t.string "format"
    t.string "imputationvar"
    t.text "var_title"
    t.string "varname"
    t.index ["varname"], name: "ipeds_program_schema_unique_id", unique: true
  end

  create_table "ipeds_programs", force: :cascade do |t|
    t.text "cipcode"
    t.integer "passoc"
    t.integer "passocde"
    t.integer "passocdes"
    t.integer "pbachl"
    t.integer "pbachlde"
    t.integer "pbachldes"
    t.integer "pcert1"
    t.integer "pcert1_a"
    t.integer "pcert1_ade"
    t.integer "pcert1_ades"
    t.integer "pcert1_b"
    t.integer "pcert1_bde"
    t.integer "pcert1_bdes"
    t.integer "pcert1_de"
    t.integer "pcert2"
    t.integer "pcert2_de"
    t.integer "pcert2_des"
    t.integer "pcert4"
    t.integer "pcert4_de"
    t.integer "pcert4_des"
    t.integer "pdocot"
    t.integer "pdocotde"
    t.integer "pdocotdes"
    t.integer "pdocpp"
    t.integer "pdocppde"
    t.integer "pdocppdes"
    t.integer "pdocrs"
    t.integer "pdocrsde"
    t.integer "pdocrsdes"
    t.integer "pmastr"
    t.integer "pmastrde"
    t.integer "pmastrdes"
    t.integer "ppbacc"
    t.integer "ppbaccde"
    t.integer "ppbaccdes"
    t.integer "ppmast"
    t.integer "ppmastde"
    t.integer "ppmastdes"
    t.integer "ptotal"
    t.integer "ptotalde"
    t.integer "ptotaldes"
    t.integer "unitid"
    t.integer "year"
    t.index ["year", "unitid", "cipcode"], name: "ipeds_programs_unique_id", unique: true
  end

  create_table "ipeds_stem_cipcodes", force: :cascade do |t|
    t.string "cip_code_2020"
    t.text "cip_code_title"
    t.string "cip_code_two_digit_series"
    t.index ["cip_code_2020"], name: "iped_stem_cipcodes_unique_id", unique: true
  end

  create_table "keyserver_app_name_overrides", force: :cascade do |t|
    t.string "canonical", null: false
    t.string "raw_name", null: false
    t.index ["raw_name"], name: "index_keyserver_app_name_overrides_on_raw_name", unique: true
  end

  create_table "keyserver_computers", force: :cascade do |t|
    t.string "computer_name", null: false
    t.datetime "created_at"
    t.string "location"
    t.string "section"
    t.datetime "updated_at"
    t.index ["computer_name"], name: "index_keyserver_computers_on_computer_name", unique: true
  end

  create_table "keyserver_divisions", force: :cascade do |t|
    t.string "division_flags"
    t.string "division_id"
    t.string "division_name"
    t.string "division_notes"
    t.string "division_section_id"
    t.string "division_server_id"
  end

  create_table "keyserver_events", force: :cascade do |t|
    t.string "address"
    t.string "application"
    t.string "computer_name"
    t.datetime "created_at"
    t.string "event_type"
    t.string "location"
    t.datetime "occurred_at"
    t.string "product"
    t.datetime "updated_at"
    t.string "user_name"
    t.string "version"
    t.index ["computer_name", "occurred_at", "application", "event_type", "user_name"], name: "index_keyserver_events_natural_key", unique: true
    t.index ["computer_name", "occurred_at"], name: "index_keyserver_events_on_computer_name_and_occurred_at"
    t.index ["computer_name"], name: "index_keyserver_events_on_computer_name"
    t.index ["location"], name: "index_keyserver_events_on_location"
    t.index ["occurred_at"], name: "index_keyserver_events_on_occurred_at"
    t.index ["user_name"], name: "index_keyserver_events_on_user_name"
  end

  create_table "keyserver_sessions", force: :cascade do |t|
    t.string "address"
    t.string "computer_name"
    t.datetime "created_at"
    t.bigint "duration"
    t.string "location"
    t.datetime "logoff"
    t.datetime "logon"
    t.datetime "updated_at"
    t.string "user_name"
    t.index ["computer_name", "logon", "logoff"], name: "index_keyserver_sessions_on_computer_name_and_logon_and_logoff"
    t.index ["computer_name", "user_name", "logon"], name: "index_keyserver_sessions_natural_key", unique: true
    t.index ["location", "logon"], name: "index_keyserver_sessions_on_location_and_logon"
    t.index ["user_name"], name: "index_keyserver_sessions_on_user_name"
  end

  create_table "library_profile_profiles", force: :cascade do |t|
    t.string "also_called"
    t.string "aserl"
    t.string "bd"
    t.string "bd_symbol"
    t.string "blc"
    t.string "btaa"
    t.string "country"
    t.string "docline_symbol"
    t.string "gwla"
    t.string "institution_name"
    t.string "library_name"
    t.string "metridoc_code"
    t.string "name_symbol"
    t.string "null_ignore"
    t.string "oclc_symbol"
    t.string "palci"
    t.string "trln"
    t.string "viva"
    t.string "zip_code_location"
  end

  create_table "library_staff_census", force: :cascade do |t|
    t.decimal "calculated_total_fte"
    t.string "employment_status"
    t.datetime "employment_status_date", precision: nil
    t.string "exempt_job_flag"
    t.string "full_part_time"
    t.datetime "hire_date", precision: nil
    t.string "job_family_group_name"
    t.string "job_family_id"
    t.string "job_family_name"
    t.integer "job_profile_id"
    t.string "job_profile_name"
    t.string "legal_first_name"
    t.string "legal_last_name"
    t.integer "manager_penn_id"
    t.datetime "occupant_from_date", precision: nil
    t.string "org_short_name"
    t.integer "penn_id"
    t.string "position_cost_center_desc"
    t.string "position_employee_type"
    t.string "position_id"
    t.integer "position_penn_cost_center"
    t.integer "position_school_ctr"
    t.string "primary_business_title"
    t.string "primary_email_address_work"
    t.decimal "primary_percent_effort"
    t.string "supervisory_org_name"
    t.integer "workday_id"
    t.string "worker_location"
    t.index ["penn_id"], name: "library_staff_census_penn_id"
    t.index ["position_id"], name: "library_staff_census_position_id"
    t.index ["workday_id"], name: "library_staff_census_workday_id"
  end

  create_table "log_job_execution_steps", force: :cascade do |t|
    t.bigint "job_execution_id", null: false
    t.text "log_text"
    t.datetime "started_at", precision: nil, null: false
    t.string "status", null: false
    t.datetime "status_set_at", precision: nil, null: false
    t.string "step_name", null: false
    t.json "step_yml", null: false
    t.index ["job_execution_id"], name: "index_log_job_execution_steps_on_job_execution_id"
  end

  create_table "log_job_executions", force: :cascade do |t|
    t.json "global_yml", null: false
    t.string "job_type", null: false
    t.text "log_text"
    t.string "mac_address"
    t.string "source_name", null: false
    t.datetime "started_at", precision: nil, null: false
    t.string "status", null: false
    t.datetime "status_set_at", precision: nil, null: false
  end

  create_table "meescan_sessions", force: :cascade do |t|
    t.string "app_version"
    t.datetime "created_at", null: false
    t.string "day_of_week"
    t.string "device_model"
    t.string "device_os"
    t.string "device_os_version"
    t.string "fiscal_year"
    t.integer "hour_of_day"
    t.integer "item_count"
    t.string "item_return"
    t.string "kiosk_id"
    t.string "language_code"
    t.string "month"
    t.string "name"
    t.float "receipt_sent"
    t.datetime "updated_at", null: false
    t.integer "year"
    t.index ["created_at", "name", "item_count", "kiosk_id"], name: "meescan_sessions_unique", unique: true
  end

  create_table "report_queries", force: :cascade do |t|
    t.string "comments"
    t.datetime "created_at", precision: nil, null: false
    t.string "from_section"
    t.string "full_sql"
    t.string "group_by_section"
    t.string "last_error_message"
    t.datetime "last_run_at", precision: nil
    t.integer "n_rows_processed"
    t.string "name", null: false
    t.string "order_direction_section"
    t.text "order_section"
    t.string "output_file_name"
    t.integer "owner_id", null: false
    t.bigint "report_template_id"
    t.text "select_section"
    t.string "status"
    t.integer "total_rows_to_process"
    t.datetime "updated_at", precision: nil, null: false
    t.string "where_section"
    t.index ["report_template_id"], name: "index_report_queries_on_report_template_id"
  end

  create_table "report_query_join_clauses", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.string "keyword"
    t.string "on_keys"
    t.bigint "report_query_id", null: false
    t.string "table"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["report_query_id"], name: "index_report_query_join_clauses_on_report_query_id"
  end

  create_table "report_template_join_clauses", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.string "keyword"
    t.string "on_keys"
    t.bigint "report_template_id", null: false
    t.string "table"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["report_template_id"], name: "index_report_template_join_clauses_on_report_template_id"
  end

  create_table "report_templates", force: :cascade do |t|
    t.string "comments"
    t.datetime "created_at", precision: nil, null: false
    t.string "from_section"
    t.string "full_sql"
    t.string "group_by_section"
    t.string "name", null: false
    t.string "order_direction_section"
    t.text "order_section"
    t.text "select_section"
    t.datetime "updated_at", precision: nil, null: false
    t.string "where_section"
  end

  create_table "reshare_borrowing_turnarounds", force: :cascade do |t|
    t.string "borrower"
    t.integer "fiscal_year"
    t.datetime "received_date", precision: nil
    t.datetime "request_date", precision: nil
    t.string "request_id"
    t.datetime "shipped_date", precision: nil
    t.decimal "time_to_receipt"
    t.decimal "time_to_ship"
    t.decimal "total_time"
    t.index ["borrower", "request_id"], name: "borrowing_turnaround_index", unique: true
  end

  create_table "reshare_directory_entries", force: :cascade do |t|
    t.string "de_id"
    t.string "de_lms_location_code"
    t.string "de_name"
    t.string "de_parent"
    t.string "de_slug"
    t.string "de_status_fk"
    t.datetime "last_updated", precision: nil
    t.string "origin"
    t.bigint "version"
    t.index ["origin", "de_id"], name: "index_reshare_directory_entries_on_origin_and_de_id", unique: true
  end

  create_table "reshare_host_lms_locations", force: :cascade do |t|
    t.string "hll_code"
    t.string "hll_corresponding_de"
    t.datetime "hll_date_created", precision: nil
    t.boolean "hll_hidden"
    t.string "hll_id"
    t.datetime "hll_last_updated", precision: nil
    t.string "hll_name"
    t.integer "hll_supply_preference"
    t.integer "hll_version"
    t.string "origin"
    t.index ["hll_id"], name: "reshare_location_index", unique: true
  end

  create_table "reshare_host_lms_shelving_locations", force: :cascade do |t|
    t.string "hlsl_code"
    t.datetime "hlsl_date_created", precision: nil
    t.boolean "hlsl_hidden"
    t.string "hlsl_id"
    t.datetime "hlsl_last_updated", precision: nil
    t.string "hlsl_name"
    t.integer "hlsl_supply_preference"
    t.integer "hlsl_version"
    t.string "origin"
    t.index ["hlsl_id"], name: "reshare_shelving_location_index", unique: true
  end

  create_table "reshare_lending_turnarounds", force: :cascade do |t|
    t.datetime "filled_date", precision: nil
    t.integer "fiscal_year"
    t.string "lender"
    t.datetime "received_date", precision: nil
    t.datetime "request_date", precision: nil
    t.string "request_id"
    t.datetime "shipped_date", precision: nil
    t.decimal "time_to_fill"
    t.decimal "time_to_receipt"
    t.decimal "time_to_ship"
    t.decimal "total_time"
    t.index ["lender", "request_id"], name: "lending_turnaround_index", unique: true
  end

  create_table "reshare_patron_request_audits", force: :cascade do |t|
    t.datetime "last_updated", precision: nil
    t.string "origin"
    t.datetime "pra_date_created", precision: nil
    t.string "pra_from_status_fk"
    t.string "pra_id"
    t.string "pra_message"
    t.string "pra_patron_request_fk"
    t.string "pra_to_status_fk"
    t.string "pra_version"
    t.index ["pra_id"], name: "index_reshare_patron_request_audits_on_pra_id", unique: true
  end

  create_table "reshare_patron_request_rota", force: :cascade do |t|
    t.datetime "last_updated", precision: nil
    t.string "origin"
    t.datetime "prr_date_created", precision: nil
    t.string "prr_directory_id_fk"
    t.string "prr_id"
    t.datetime "prr_last_updated", precision: nil
    t.string "prr_lb_reason"
    t.integer "prr_lb_score"
    t.string "prr_patron_request_fk"
    t.string "prr_peer_symbol_fk"
    t.integer "prr_rota_position"
    t.string "prr_state_fk"
    t.string "prr_version"
    t.index ["prr_id"], name: "index_reshare_patron_request_rota_on_prr_id", unique: true
  end

  create_table "reshare_patron_requests", force: :cascade do |t|
    t.datetime "last_updated", precision: nil
    t.string "origin"
    t.string "pr_bib_record"
    t.datetime "pr_date_created", precision: nil
    t.datetime "pr_due_date_from_lms", precision: nil
    t.datetime "pr_due_date_rs", precision: nil
    t.string "pr_hrid"
    t.string "pr_id"
    t.boolean "pr_is_requester"
    t.string "pr_local_call_number"
    t.string "pr_oclc_number"
    t.boolean "pr_overdue"
    t.datetime "pr_parsed_due_date_lms", precision: nil
    t.datetime "pr_parsed_due_date_rs", precision: nil
    t.string "pr_patron_identifier"
    t.string "pr_patron_type"
    t.string "pr_pick_location_fk"
    t.string "pr_pick_shelving_location"
    t.string "pr_pick_shelving_location_fk"
    t.string "pr_pickup_location_slug"
    t.string "pr_place_of_pub"
    t.string "pr_pub_date"
    t.string "pr_publisher"
    t.string "pr_resolved_pickup_location_fk"
    t.string "pr_resolved_req_inst_symbol_fk"
    t.string "pr_resolved_sup_inst_symbol_fk"
    t.integer "pr_rota_position"
    t.string "pr_selected_item_barcode"
    t.string "pr_state_fk"
    t.string "pr_title"
    t.bigint "pr_version"
    t.index ["pr_id"], name: "index_reshare_patron_requests_on_pr_id", unique: true
  end

  create_table "reshare_status", force: :cascade do |t|
    t.datetime "last_updated", precision: nil
    t.string "origin"
    t.string "st_code"
    t.string "st_id"
    t.string "st_version"
    t.index ["st_id"], name: "index_reshare_status_on_st_id", unique: true
  end

  create_table "reshare_symbols", force: :cascade do |t|
    t.datetime "last_updated", precision: nil
    t.string "origin"
    t.string "sym_id"
    t.string "sym_owner_fk"
    t.string "sym_symbol"
    t.string "sym_version"
    t.index ["sym_id"], name: "index_reshare_symbols_on_sym_id", unique: true
  end

  create_table "reshare_transactions", force: :cascade do |t|
    t.string "barcode"
    t.string "borrower"
    t.string "borrower_id"
    t.datetime "borrower_last_updated", precision: nil
    t.string "borrower_status"
    t.string "call_number"
    t.datetime "date_created", precision: nil
    t.integer "fiscal_year"
    t.string "lender"
    t.string "lender_id"
    t.datetime "lender_last_updated", precision: nil
    t.string "lender_status"
    t.string "oclc_number"
    t.string "pick_location"
    t.string "pickup_location"
    t.string "place_of_publication"
    t.string "publication_date"
    t.string "publisher"
    t.string "request_id"
    t.string "shelving_location"
    t.string "title"
    t.index ["borrower_id", "lender_id"], name: "transaction_index", unique: true
  end

  create_table "sd_sp_entries", force: :cascade do |t|
    t.string "button"
    t.string "computer_id"
    t.datetime "downloaded_at"
    t.datetime "timestamp"
    t.string "username"
    t.index ["computer_id", "timestamp"], name: "sd_sp_entry_id", unique: true
  end

  create_table "sd_sp_queries", force: :cascade do |t|
    t.float "capacity_units"
    t.integer "count"
    t.datetime "downloaded_at"
    t.integer "scanned_count"
    t.index ["downloaded_at"], name: "index_sd_sp_queries_on_downloaded_at", unique: true
  end

  create_table "ss_libanswers_queues", force: :cascade do |t|
    t.string "email_address"
    t.datetime "last_modified"
    t.string "name"
    t.integer "number_of_tickets", default: 0
    t.integer "queue_id"
    t.index ["queue_id"], name: "ss_libanswers_queue_id", unique: true
  end

  create_table "ss_libanswers_tickets", force: :cascade do |t|
    t.datetime "asked_on"
    t.text "details"
    t.string "email"
    t.integer "interactions"
    t.datetime "last_updated"
    t.string "name"
    t.string "owner"
    t.string "penn_id"
    t.string "pennkey"
    t.text "question"
    t.integer "queue_id"
    t.string "school", default: "Unknown"
    t.string "source"
    t.string "statistical_category_1"
    t.string "statistical_category_2"
    t.string "statistical_category_3"
    t.string "statistical_category_4"
    t.string "statistical_category_5"
    t.string "status"
    t.string "tags"
    t.integer "ticket_id"
    t.interval "time_to_close"
    t.interval "time_to_first_reply"
    t.string "user_group", default: "Unknown"
    t.index ["ticket_id"], name: "ss_libanswers_ticket_id", unique: true
  end

  create_table "ss_libcal_answers", force: :cascade do |t|
    t.string "answer"
    t.integer "appointment_id"
    t.text "question_id"
    t.integer "staff_id"
    t.index ["appointment_id", "question_id"], name: "ss_libcal_answers_id", unique: true
  end

  create_table "ss_libcal_appointments", force: :cascade do |t|
    t.json "answers"
    t.integer "appointment_id"
    t.boolean "cancelled"
    t.integer "category_id"
    t.string "directions"
    t.date "downloaded_at"
    t.date "from_date"
    t.string "group"
    t.integer "group_id"
    t.string "location"
    t.integer "location_id"
    t.string "patron_email"
    t.string "patron_first_name"
    t.string "patron_last_name"
    t.integer "staff_id"
    t.date "to_date"
    t.index ["appointment_id"], name: "ss_libcal_appointments_id", unique: true
    t.index ["downloaded_at"], name: "ss_libcal_appointments_downloaded_at"
    t.index ["from_date"], name: "ss_libcal_appointments_from_date"
    t.index ["group"], name: "ss_libcal_appointments_group"
    t.index ["location"], name: "ss_libcal_appointments_location"
    t.index ["staff_id"], name: "ss_libcal_appointments_staff_id"
  end

  create_table "ss_libcal_questions", force: :cascade do |t|
    t.string "answer_type"
    t.string "label"
    t.json "options"
    t.integer "question_id"
    t.boolean "required"
    t.index ["question_id"], name: "ss_libcal_questions_id", unique: true
  end

  create_table "ss_libcal_space_answers", force: :cascade do |t|
    t.string "answer"
    t.integer "booking_id"
    t.string "question_key"
    t.index ["booking_id", "question_key"], name: "ss_libcal_space_answer_id", unique: true
  end

  create_table "ss_libcal_space_bookings", force: :cascade do |t|
    t.string "account"
    t.json "answers"
    t.integer "booking_id"
    t.string "booking_key"
    t.datetime "cancelled"
    t.integer "category_id"
    t.string "category_name"
    t.datetime "created"
    t.datetime "downloaded_at"
    t.string "email"
    t.json "event"
    t.string "first_name"
    t.datetime "from_date"
    t.integer "item_id"
    t.string "item_name"
    t.string "last_name"
    t.integer "location_id"
    t.string "location_name"
    t.string "nickname"
    t.string "penn_id"
    t.string "pennkey"
    t.string "school"
    t.string "statistical_category_1"
    t.string "statistical_category_2"
    t.string "statistical_category_3"
    t.string "statistical_category_4"
    t.string "statistical_category_5"
    t.string "status"
    t.datetime "to_date"
    t.string "user_group"
    t.index ["booking_id"], name: "ss_libcal_space_booking_id", unique: true
  end

  create_table "ss_libcal_space_forms", force: :cascade do |t|
    t.json "fields"
    t.integer "form_id"
    t.string "name"
    t.index ["form_id"], name: "ss_libcal_space_form_id", unique: true
  end

  create_table "ss_libcal_space_locations", force: :cascade do |t|
    t.integer "form_id"
    t.integer "location_id"
    t.string "location_name"
    t.boolean "public"
    t.index ["location_id"], name: "ss_libcal_space_location_id", unique: true
  end

  create_table "ss_libcal_space_questions", force: :cascade do |t|
    t.integer "form_id"
    t.string "label"
    t.json "options"
    t.integer "question_id"
    t.string "question_key"
    t.string "question_type"
    t.boolean "required"
    t.index ["form_id", "question_key"], name: "ss_libcal_space_question_id", unique: true
  end

  create_table "ss_libcal_users", force: :cascade do |t|
    t.string "email"
    t.string "first_name"
    t.string "last_name"
    t.integer "staff_id"
    t.index ["staff_id"], name: "ss_libcal_users_id", unique: true
  end

  create_table "ss_libchat_chats", force: :cascade do |t|
    t.string "answerer"
    t.integer "chat_id"
    t.string "comment"
    t.string "contact_info"
    t.string "department"
    t.integer "display_name"
    t.integer "duration"
    t.integer "fiscal_year"
    t.string "initial_question"
    t.string "internal_note"
    t.integer "message_count"
    t.string "name"
    t.string "penn_id"
    t.string "pennkey"
    t.string "referrer"
    t.string "referrer_basename"
    t.string "school", default: "Unknown"
    t.string "statistical_category_1"
    t.string "statistical_category_2"
    t.string "statistical_category_3"
    t.string "statistical_category_4"
    t.string "statistical_category_5"
    t.integer "ticket_id"
    t.datetime "timestamp"
    t.string "transcript"
    t.string "transfer_history"
    t.string "user_field_1"
    t.string "user_field_2"
    t.string "user_field_3"
    t.string "user_group", default: "Unknown"
    t.integer "wait_time"
    t.string "widget"
    t.index ["chat_id"], name: "ss_libchat_chats_id", unique: true
  end

  create_table "ss_libchat_inquirymap", force: :cascade do |t|
    t.integer "account_q"
    t.bigint "chat_id"
    t.integer "medium"
    t.integer "newspaper"
    t.string "sentiment"
    t.float "sentiment_score"
    t.integer "services"
    t.integer "subscription_issues"
    t.integer "top_searches"
    t.integer "type_of_search"
    t.string "user_type"
    t.index ["chat_id"], name: "index_ss_libchat_inquirymap_on_chat_id"
  end

  create_table "ss_libwizard_candi_autos", force: :cascade do |t|
    t.string "academic_department"
    t.string "additional_staff_pennkey"
    t.string "campus"
    t.string "consultation_or_instruction"
    t.string "course_name"
    t.string "course_number"
    t.string "course_sponsor"
    t.string "department_csc"
    t.string "department_ope"
    t.string "department_tdi"
    t.string "departmental_library"
    t.string "division"
    t.datetime "downloaded_at"
    t.date "event_date"
    t.integer "event_length"
    t.string "faculty_sponsor"
    t.string "graduate_student_type"
    t.integer "graduation_year"
    t.string "location"
    t.string "mba_type"
    t.string "mode_of_consultation"
    t.text "notes"
    t.integer "number_of_interactions"
    t.integer "number_of_registrations"
    t.string "outcome"
    t.string "patron_name"
    t.string "patron_question"
    t.string "patron_type"
    t.string "physical_or_electronic"
    t.integer "prep_time"
    t.string "research_community"
    t.string "response_id"
    t.string "rtg"
    t.string "school_affiliation"
    t.string "service_provided"
    t.string "service_space_or_information"
    t.text "session_description"
    t.string "session_type"
    t.string "staff_expertise"
    t.string "staff_pennkey"
    t.datetime "submitted", precision: nil
    t.integer "total_attendance"
    t.string "undergraduate_student_type"
    t.boolean "upload_record", default: false
    t.index ["response_id"], name: "index_ss_libwizard_candi_autos_on_response_id", unique: true
  end

  create_table "ss_libwizard_candi_legacies", force: :cascade do |t|
    t.string "additional_staff_pennkey"
    t.string "campus"
    t.string "consultation_or_instruction"
    t.string "course_name"
    t.string "course_number"
    t.string "course_sponsor"
    t.string "department"
    t.date "event_date"
    t.integer "event_length"
    t.string "faculty_sponsor"
    t.string "graduate_student_type"
    t.integer "graduation_year"
    t.string "location"
    t.string "mba_type"
    t.string "mode_of_consultation"
    t.text "notes"
    t.integer "number_of_interactions"
    t.integer "number_of_registrations"
    t.string "outcome"
    t.string "patron_name"
    t.string "patron_question"
    t.string "patron_type"
    t.integer "prep_time"
    t.string "referral_method"
    t.string "research_community"
    t.boolean "returning_user"
    t.string "rtg"
    t.string "school_affiliation"
    t.string "service_provided"
    t.text "session_description"
    t.string "session_type"
    t.string "staff_expertise"
    t.string "staff_pennkey"
    t.datetime "submitted", precision: nil
    t.integer "total_attendance"
    t.string "undergraduate_student_type"
    t.boolean "upload_record", default: true
    t.index ["outcome"], name: "index_ss_libwizard_candi_legacies_on_outcome"
    t.index ["patron_question"], name: "index_ss_libwizard_candi_legacies_on_patron_question"
    t.index ["staff_pennkey"], name: "index_ss_libwizard_candi_legacies_on_staff_pennkey"
  end

  create_table "ss_libwizard_candi_manuals", force: :cascade do |t|
    t.string "academic_department"
    t.string "additional_staff_pennkey"
    t.string "campus"
    t.string "consultation_or_instruction"
    t.string "course_name"
    t.string "course_number"
    t.string "course_sponsor"
    t.string "department_csc"
    t.string "department_operations"
    t.string "department_tdi"
    t.string "departmental_library"
    t.string "division"
    t.date "event_date"
    t.integer "event_length"
    t.string "faculty_sponsor"
    t.string "filename"
    t.string "graduate_student_type"
    t.integer "graduation_year"
    t.string "location"
    t.string "mba_type"
    t.string "mode_of_consultation"
    t.text "notes"
    t.integer "number_of_interactions"
    t.integer "number_of_registrations"
    t.string "outcome"
    t.string "patron_name"
    t.string "patron_question"
    t.string "patron_type"
    t.string "physical_or_electronic_access"
    t.integer "prep_time"
    t.string "research_community"
    t.string "response_id"
    t.string "rtg"
    t.string "school_affiliation"
    t.string "service_provided"
    t.text "session_description"
    t.string "session_type"
    t.string "staff_expertise"
    t.string "staff_pennkey"
    t.integer "total_attendance"
    t.string "type_of_access_question"
    t.string "undergraduate_student_type"
    t.boolean "upload_record", default: true
    t.datetime "uploaded_at"
  end

  create_table "ss_libwizard_etlms", force: :cascade do |t|
    t.string "academic_department"
    t.string "additional_staff_pennkey"
    t.string "career_advancement"
    t.integer "communication"
    t.string "consultation_or_instruction"
    t.string "course_name"
    t.string "course_number"
    t.string "course_sponsor"
    t.datetime "downloaded_at"
    t.integer "effectiveness"
    t.integer "efficiency"
    t.integer "engagement"
    t.string "equipment_type"
    t.string "equipment_used"
    t.date "event_date"
    t.integer "event_length"
    t.string "faculty_sponsor"
    t.boolean "first_visit"
    t.string "graduate_student_type"
    t.string "graduation_year"
    t.boolean "is_staff"
    t.string "location"
    t.string "mode_of_consultation"
    t.text "notes"
    t.integer "number_of_registrations"
    t.string "outcome"
    t.string "patron_email"
    t.string "patron_name"
    t.string "patron_question"
    t.string "patron_type"
    t.integer "prep_time"
    t.string "referral"
    t.date "requested_event_date"
    t.string "response_id"
    t.string "school_affiliation"
    t.string "service_provided"
    t.text "session_description"
    t.string "staff_pennkey"
    t.string "status"
    t.string "strategic_priority"
    t.datetime "submitted", precision: nil
    t.integer "support"
    t.integer "total_attendance"
    t.string "undergraduate_student_type"
    t.boolean "workshop_agreement"
    t.string "workshop_budget"
    t.string "workshop_cost"
    t.string "workshop_title"
    t.index ["response_id"], name: "index_ss_libwizard_etlms_on_response_id", unique: true
  end

  create_table "upenn_academic_calendars", force: :cascade do |t|
    t.integer "calendar_year"
    t.date "end_date"
    t.integer "fiscal_year"
    t.date "start_date"
    t.string "term"
    t.index ["fiscal_year", "term"], name: "upenn_academic_calendar_term_id", unique: true
  end

  create_table "upenn_alma_demographics", force: :cascade do |t|
    t.text "email"
    t.text "first_name"
    t.text "last_name"
    t.text "penn_id", null: false
    t.string "pennkey", limit: 8, null: false
    t.string "school"
    t.string "statistical_category_1"
    t.string "statistical_category_2"
    t.string "statistical_category_3"
    t.string "statistical_category_4"
    t.string "statistical_category_5"
    t.string "status"
    t.date "status_date"
    t.text "user_group"
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
    t.integer "fiscal_year"
    t.string "school"
    t.string "school_parent"
    t.string "user_parent"
    t.string "user_type"
    t.integer "value"
    t.index ["user_type", "school", "fiscal_year"], name: "upenn_enrollments_uid", unique: true
  end

  create_table "upenn_library_doors", force: :cascade do |t|
    t.string "door_name"
    t.string "library_code"
    t.string "library_name"
    t.index ["door_name"], name: "index_upenn_library_doors_on_door_name", unique: true
  end

  create_table "upenn_school_names", force: :cascade do |t|
    t.string "alma_affiliations"
    t.string "code"
    t.string "ira_affiliations"
    t.boolean "is_school"
    t.index ["alma_affiliations"], name: "index_upenn_school_names_on_alma_affiliations", unique: true
  end

  create_table "user_role_sections", force: :cascade do |t|
    t.string "access_level", null: false
    t.datetime "created_at", precision: nil, null: false
    t.string "section", null: false
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "user_role_id", null: false
    t.index ["user_role_id"], name: "index_user_role_sections_on_user_role_id"
  end

  create_table "user_roles", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.string "name", null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "admin_users", "user_roles"
  add_foreign_key "file_upload_import_logs", "file_upload_imports"
  add_foreign_key "user_role_sections", "user_roles"

  create_view "candi_views", sql_definition: <<-SQL
      SELECT ('A'::text || ss_libwizard_candi_autos.id) AS id,
      ss_libwizard_candi_autos.response_id,
      ss_libwizard_candi_autos.submitted,
      ss_libwizard_candi_autos.consultation_or_instruction,
      ss_libwizard_candi_autos.staff_pennkey,
      ss_libwizard_candi_autos.additional_staff_pennkey,
      ss_libwizard_candi_autos.division,
      ss_libwizard_candi_autos.department_csc,
      ss_libwizard_candi_autos.department_ope,
      ss_libwizard_candi_autos.department_tdi,
      ss_libwizard_candi_autos.departmental_library,
      ss_libwizard_candi_autos.staff_expertise,
      ss_libwizard_candi_autos.event_date,
      ss_libwizard_candi_autos.mode_of_consultation,
      ss_libwizard_candi_autos.rtg,
      ss_libwizard_candi_autos.session_type,
      ss_libwizard_candi_autos.service_provided,
      ss_libwizard_candi_autos.service_space_or_information,
      ss_libwizard_candi_autos.physical_or_electronic,
      ss_libwizard_candi_autos.outcome,
      ss_libwizard_candi_autos.research_community,
      ss_libwizard_candi_autos.number_of_registrations,
      ss_libwizard_candi_autos.total_attendance,
      ss_libwizard_candi_autos.location,
      ss_libwizard_candi_autos.event_length,
      ss_libwizard_candi_autos.prep_time,
      ss_libwizard_candi_autos.number_of_interactions,
      ss_libwizard_candi_autos.patron_type,
      ss_libwizard_candi_autos.undergraduate_student_type,
      ss_libwizard_candi_autos.graduate_student_type,
      ss_libwizard_candi_autos.mba_type,
      ss_libwizard_candi_autos.campus,
      ss_libwizard_candi_autos.patron_name,
      ss_libwizard_candi_autos.school_affiliation,
      ss_libwizard_candi_autos.graduation_year,
      ss_libwizard_candi_autos.academic_department,
      ss_libwizard_candi_autos.faculty_sponsor,
      ss_libwizard_candi_autos.course_sponsor,
      ss_libwizard_candi_autos.course_name,
      ss_libwizard_candi_autos.course_number,
      ss_libwizard_candi_autos.patron_question,
      ss_libwizard_candi_autos.session_description,
      ss_libwizard_candi_autos.notes,
      ss_libwizard_candi_autos.downloaded_at,
      ss_libwizard_candi_autos.upload_record,
      NULL::text AS referral_method,
      false AS returning_user
     FROM ss_libwizard_candi_autos
  UNION
   SELECT ('M'::text || ss_libwizard_candi_manuals.id) AS id,
      NULL::character varying AS response_id,
      NULL::timestamp without time zone AS submitted,
      ss_libwizard_candi_manuals.consultation_or_instruction,
      ss_libwizard_candi_manuals.staff_pennkey,
      ss_libwizard_candi_manuals.additional_staff_pennkey,
      ss_libwizard_candi_manuals.division,
      ss_libwizard_candi_manuals.department_csc,
      ss_libwizard_candi_manuals.department_operations AS department_ope,
      ss_libwizard_candi_manuals.department_tdi,
      ss_libwizard_candi_manuals.departmental_library,
      ss_libwizard_candi_manuals.staff_expertise,
      ss_libwizard_candi_manuals.event_date,
      ss_libwizard_candi_manuals.mode_of_consultation,
      ss_libwizard_candi_manuals.rtg,
      ss_libwizard_candi_manuals.session_type,
      ss_libwizard_candi_manuals.service_provided,
      ss_libwizard_candi_manuals.type_of_access_question AS service_space_or_information,
      ss_libwizard_candi_manuals.physical_or_electronic_access AS physical_or_electronic,
      ss_libwizard_candi_manuals.outcome,
      ss_libwizard_candi_manuals.research_community,
      ss_libwizard_candi_manuals.number_of_registrations,
      ss_libwizard_candi_manuals.total_attendance,
      ss_libwizard_candi_manuals.location,
      ss_libwizard_candi_manuals.event_length,
      ss_libwizard_candi_manuals.prep_time,
      ss_libwizard_candi_manuals.number_of_interactions,
      ss_libwizard_candi_manuals.patron_type,
      ss_libwizard_candi_manuals.undergraduate_student_type,
      ss_libwizard_candi_manuals.graduate_student_type,
      ss_libwizard_candi_manuals.mba_type,
      ss_libwizard_candi_manuals.campus,
      ss_libwizard_candi_manuals.patron_name,
      ss_libwizard_candi_manuals.school_affiliation,
      ss_libwizard_candi_manuals.graduation_year,
      ss_libwizard_candi_manuals.academic_department,
      ss_libwizard_candi_manuals.faculty_sponsor,
      ss_libwizard_candi_manuals.course_sponsor,
      ss_libwizard_candi_manuals.course_name,
      ss_libwizard_candi_manuals.course_number,
      ss_libwizard_candi_manuals.patron_question,
      ss_libwizard_candi_manuals.session_description,
      ss_libwizard_candi_manuals.notes,
      ss_libwizard_candi_manuals.uploaded_at AS downloaded_at,
      ss_libwizard_candi_manuals.upload_record,
      NULL::text AS referral_method,
      false AS returning_user
     FROM ss_libwizard_candi_manuals
  UNION
   SELECT ('L'::text || ss_libwizard_candi_legacies.id) AS id,
      NULL::character varying AS response_id,
      ss_libwizard_candi_legacies.submitted,
      ss_libwizard_candi_legacies.consultation_or_instruction,
      ss_libwizard_candi_legacies.staff_pennkey,
      ss_libwizard_candi_legacies.additional_staff_pennkey,
      NULL::character varying AS division,
      NULL::character varying AS department_csc,
      NULL::character varying AS department_ope,
      NULL::character varying AS department_tdi,
      NULL::character varying AS departmental_library,
      ss_libwizard_candi_legacies.staff_expertise,
      ss_libwizard_candi_legacies.event_date,
      ss_libwizard_candi_legacies.mode_of_consultation,
      ss_libwizard_candi_legacies.rtg,
      ss_libwizard_candi_legacies.session_type,
      ss_libwizard_candi_legacies.service_provided,
      NULL::character varying AS service_space_or_information,
      NULL::character varying AS physical_or_electronic,
      ss_libwizard_candi_legacies.outcome,
      ss_libwizard_candi_legacies.research_community,
      ss_libwizard_candi_legacies.number_of_registrations,
      ss_libwizard_candi_legacies.total_attendance,
      ss_libwizard_candi_legacies.location,
      ss_libwizard_candi_legacies.event_length,
      ss_libwizard_candi_legacies.prep_time,
      ss_libwizard_candi_legacies.number_of_interactions,
      ss_libwizard_candi_legacies.patron_type,
      ss_libwizard_candi_legacies.undergraduate_student_type,
      ss_libwizard_candi_legacies.graduate_student_type,
      ss_libwizard_candi_legacies.mba_type,
      ss_libwizard_candi_legacies.campus,
      ss_libwizard_candi_legacies.patron_name,
      ss_libwizard_candi_legacies.school_affiliation,
      ss_libwizard_candi_legacies.graduation_year,
      ss_libwizard_candi_legacies.department AS academic_department,
      ss_libwizard_candi_legacies.faculty_sponsor,
      ss_libwizard_candi_legacies.course_sponsor,
      ss_libwizard_candi_legacies.course_name,
      ss_libwizard_candi_legacies.course_number,
      ss_libwizard_candi_legacies.patron_question,
      ss_libwizard_candi_legacies.session_description,
      ss_libwizard_candi_legacies.notes,
      NULL::timestamp without time zone AS downloaded_at,
      ss_libwizard_candi_legacies.upload_record,
      ss_libwizard_candi_legacies.referral_method,
      ss_libwizard_candi_legacies.returning_user
     FROM ss_libwizard_candi_legacies;
  SQL
  create_view "cr_leganto_usage_views", sql_definition: <<-SQL
      SELECT lu.id,
      lu.event_date,
      lc.course_year,
      lc.course_term,
      lc.academic_department,
      lc.course_code,
      lc.course_name,
      lc.course_enrollment,
      lu.course_id,
      lu.reading_list_id,
      lu.citation_id,
      COALESCE(NULLIF(COALESCE(NULLIF((lci.title)::text, ''::text), (lci.book_chapter_title)::text), ''::text), (lci.journal_title)::text) AS title,
      lci.author,
      lu.user_role,
      lu.files_downloaded,
      lu.file_views,
      lu.full_text_views,
      lu.total_views,
      lc.processing_department
     FROM ((cr_leganto_usage lu
       LEFT JOIN cr_leganto_courses lc ON ((lu.course_id = lc.course_id)))
       LEFT JOIN cr_leganto_citations lci ON ((lu.citation_id = lci.citation_id)))
    WHERE ((lu.total_views <> 0) AND (lc.course_id <> '7988545480003681'::bigint));
  SQL
  create_view "keyserver_location_by_dows", sql_definition: <<-SQL
      SELECT row_number() OVER (ORDER BY keyserver_sessions.location, ((date_part('dow'::text, keyserver_sessions.logon))::integer)) AS id,
      keyserver_sessions.location,
      (date_part('dow'::text, keyserver_sessions.logon))::integer AS day_of_week,
      to_char(keyserver_sessions.logon, 'Dy'::text) AS day_name,
      count(*) AS sessions
     FROM keyserver_sessions
    WHERE ((keyserver_sessions.location IS NOT NULL) AND ((keyserver_sessions.location)::text <> ''::text) AND (keyserver_sessions.logon IS NOT NULL))
    GROUP BY keyserver_sessions.location, ((date_part('dow'::text, keyserver_sessions.logon))::integer), (to_char(keyserver_sessions.logon, 'Dy'::text))
    ORDER BY keyserver_sessions.location, ((date_part('dow'::text, keyserver_sessions.logon))::integer);
  SQL
  create_view "keyserver_location_by_hours", sql_definition: <<-SQL
      SELECT row_number() OVER (ORDER BY keyserver_sessions.location, ((date_part('hour'::text, keyserver_sessions.logon))::integer)) AS id,
      keyserver_sessions.location,
      (date_part('hour'::text, keyserver_sessions.logon))::integer AS hour_of_day,
      count(*) AS sessions
     FROM keyserver_sessions
    WHERE ((keyserver_sessions.location IS NOT NULL) AND ((keyserver_sessions.location)::text <> ''::text) AND (keyserver_sessions.logon IS NOT NULL))
    GROUP BY keyserver_sessions.location, ((date_part('hour'::text, keyserver_sessions.logon))::integer)
    ORDER BY keyserver_sessions.location, ((date_part('hour'::text, keyserver_sessions.logon))::integer);
  SQL
  create_view "keyserver_non_staff_computers", sql_definition: <<-SQL
      SELECT keyserver_sessions.computer_name
     FROM keyserver_sessions
    WHERE ((keyserver_sessions.computer_name IS NOT NULL) AND ((keyserver_sessions.computer_name)::text <> ''::text) AND ((keyserver_sessions.computer_name)::text <> 'Computer Not Found'::text))
    GROUP BY keyserver_sessions.computer_name
   HAVING ((count(*) FILTER (WHERE ((keyserver_sessions.location IS NOT NULL) AND ((keyserver_sessions.location)::text <> ''::text) AND ((keyserver_sessions.location)::text <> 'Staff'::text))) > 0) AND (count(*) FILTER (WHERE ((keyserver_sessions.location)::text = 'Staff'::text)) = 0));
  SQL
  create_view "keyserver_software_usage_by_schools", sql_definition: <<-SQL
      WITH non_staff_computers AS (
           SELECT keyserver_sessions.computer_name
             FROM keyserver_sessions
            WHERE ((keyserver_sessions.computer_name IS NOT NULL) AND ((keyserver_sessions.computer_name)::text <> ''::text) AND ((keyserver_sessions.computer_name)::text <> 'Computer Not Found'::text))
            GROUP BY keyserver_sessions.computer_name
           HAVING ((count(*) FILTER (WHERE ((keyserver_sessions.location IS NOT NULL) AND ((keyserver_sessions.location)::text <> ''::text) AND ((keyserver_sessions.location)::text <> 'Staff'::text))) > 0) AND (count(*) FILTER (WHERE ((keyserver_sessions.location)::text = 'Staff'::text)) = 0))
          )
   SELECT row_number() OVER (ORDER BY e.product, d.school) AS id,
      e.product,
      d.school,
      count(*) AS checkouts,
      count(DISTINCT e.user_name) AS distinct_users
     FROM ((keyserver_events e
       JOIN non_staff_computers ns ON (((e.computer_name)::text = (ns.computer_name)::text)))
       LEFT JOIN upenn_alma_demographics d ON (((e.user_name)::text = (d.pennkey)::text)))
    WHERE ((e.product IS NOT NULL) AND ((e.product)::text <> ''::text) AND ((e.event_type)::text = ANY (ARRAY[('launch'::character varying)::text, ('logged launch'::character varying)::text, ('launch offline'::character varying)::text, ('logged launch offline'::character varying)::text, ('license start'::character varying)::text, ('product usage start'::character varying)::text])))
    GROUP BY e.product, d.school
    ORDER BY e.product, d.school;
  SQL
  create_view "keyserver_software_usage_by_user_groups", sql_definition: <<-SQL
      WITH non_staff_computers AS (
           SELECT keyserver_sessions.computer_name
             FROM keyserver_sessions
            WHERE ((keyserver_sessions.computer_name IS NOT NULL) AND ((keyserver_sessions.computer_name)::text <> ''::text) AND ((keyserver_sessions.computer_name)::text <> 'Computer Not Found'::text))
            GROUP BY keyserver_sessions.computer_name
           HAVING ((count(*) FILTER (WHERE ((keyserver_sessions.location IS NOT NULL) AND ((keyserver_sessions.location)::text <> ''::text) AND ((keyserver_sessions.location)::text <> 'Staff'::text))) > 0) AND (count(*) FILTER (WHERE ((keyserver_sessions.location)::text = 'Staff'::text)) = 0))
          )
   SELECT row_number() OVER (ORDER BY e.product, d.user_group) AS id,
      e.product,
      d.user_group,
      count(*) AS checkouts,
      count(DISTINCT e.user_name) AS distinct_users
     FROM ((keyserver_events e
       JOIN non_staff_computers ns ON (((e.computer_name)::text = (ns.computer_name)::text)))
       LEFT JOIN upenn_alma_demographics d ON (((e.user_name)::text = (d.pennkey)::text)))
    WHERE ((e.product IS NOT NULL) AND ((e.product)::text <> ''::text) AND ((e.event_type)::text = ANY (ARRAY[('launch'::character varying)::text, ('logged launch'::character varying)::text, ('launch offline'::character varying)::text, ('logged launch offline'::character varying)::text, ('license start'::character varying)::text, ('product usage start'::character varying)::text])))
    GROUP BY e.product, d.user_group
    ORDER BY e.product, d.user_group;
  SQL
  create_view "keyserver_software_usage_profiles", sql_definition: <<-SQL
      WITH non_staff_computers AS (
           SELECT keyserver_sessions.computer_name
             FROM keyserver_sessions
            WHERE ((keyserver_sessions.computer_name IS NOT NULL) AND ((keyserver_sessions.computer_name)::text <> ''::text) AND ((keyserver_sessions.computer_name)::text <> 'Computer Not Found'::text))
            GROUP BY keyserver_sessions.computer_name
           HAVING ((count(*) FILTER (WHERE ((keyserver_sessions.location IS NOT NULL) AND ((keyserver_sessions.location)::text <> ''::text) AND ((keyserver_sessions.location)::text <> 'Staff'::text))) > 0) AND (count(*) FILTER (WHERE ((keyserver_sessions.location)::text = 'Staff'::text)) = 0))
          ), dataset_ceiling AS (
           SELECT max(keyserver_events.occurred_at) AS ceiling_date
             FROM keyserver_events
          ), usage AS (
           SELECT e.product,
              count(*) FILTER (WHERE ((e.event_type)::text = ANY (ARRAY[('launch'::character varying)::text, ('logged launch'::character varying)::text, ('launch offline'::character varying)::text, ('logged launch offline'::character varying)::text, ('license start'::character varying)::text, ('product usage start'::character varying)::text]))) AS checkouts,
              count(DISTINCT e.user_name) FILTER (WHERE ((e.event_type)::text = ANY (ARRAY[('launch'::character varying)::text, ('logged launch'::character varying)::text, ('launch offline'::character varying)::text, ('logged launch offline'::character varying)::text, ('license start'::character varying)::text, ('product usage start'::character varying)::text]))) AS distinct_users,
              min(e.occurred_at) FILTER (WHERE ((e.event_type)::text = ANY (ARRAY[('launch'::character varying)::text, ('logged launch'::character varying)::text, ('launch offline'::character varying)::text, ('logged launch offline'::character varying)::text, ('license start'::character varying)::text, ('product usage start'::character varying)::text]))) AS first_checkout,
              max(e.occurred_at) FILTER (WHERE ((e.event_type)::text = ANY (ARRAY[('launch'::character varying)::text, ('logged launch'::character varying)::text, ('launch offline'::character varying)::text, ('logged launch offline'::character varying)::text, ('license start'::character varying)::text, ('product usage start'::character varying)::text]))) AS last_checkout
             FROM (keyserver_events e
               JOIN non_staff_computers ns USING (computer_name))
            WHERE ((e.product IS NOT NULL) AND ((e.product)::text <> ''::text) AND ((e.event_type)::text <> ALL (ARRAY[('obtain'::character varying)::text, ('return'::character varying)::text, ('logon'::character varying)::text, ('logoff'::character varying)::text, ('block'::character varying)::text, ('info'::character varying)::text, ('up'::character varying)::text, ('down'::character varying)::text, ('shadow info'::character varying)::text, ('shadow up'::character varying)::text, ('shadow down'::character varying)::text, ('audited'::character varying)::text, ('issued'::character varying)::text, ('revoked'::character varying)::text, ('deny unkeyed'::character varying)::text, ('session idle start'::character varying)::text, ('session idle stop'::character varying)::text])))
            GROUP BY e.product
           HAVING (count(*) FILTER (WHERE ((e.event_type)::text = ANY (ARRAY[('launch'::character varying)::text, ('logged launch'::character varying)::text, ('launch offline'::character varying)::text, ('logged launch offline'::character varying)::text, ('license start'::character varying)::text, ('product usage start'::character varying)::text]))) > 0)
          )
   SELECT u.product,
      u.checkouts,
      u.distinct_users,
      round(((u.checkouts)::numeric / (NULLIF(u.distinct_users, 0))::numeric), 1) AS sessions_per_user,
      u.first_checkout,
      u.last_checkout,
      ((dc.ceiling_date)::date - (u.last_checkout)::date) AS days_since_checkout,
          CASE
              WHEN (((dc.ceiling_date)::date - (u.last_checkout)::date) <= 90) THEN 'Active'::text
              WHEN (((dc.ceiling_date)::date - (u.last_checkout)::date) <= 365) THEN 'Stale'::text
              ELSE 'Dormant'::text
          END AS status
     FROM (usage u
       CROSS JOIN dataset_ceiling dc)
    ORDER BY u.checkouts DESC;
  SQL
  create_view "ss_libchat_combined_views", sql_definition: <<-SQL
      SELECT c.id AS chat_id,
      c.fiscal_year,
      c."timestamp",
      c.department,
      c.widget,
      c.answerer,
      c.referrer,
      c.wait_time,
      c.duration,
      c.message_count,
      c.initial_question,
      c.transfer_history,
      c.ticket_id,
      c.user_group,
      c.school,
      c.statistical_category_1,
      c.statistical_category_2,
      c.statistical_category_3,
      c.statistical_category_4,
      c.statistical_category_5,
      im.newspaper,
      im.medium,
      im.top_searches,
      im.services,
      im.account_q,
      im.subscription_issues,
      im.type_of_search
     FROM (ss_libchat_chats c
       LEFT JOIN ss_libchat_inquirymap im ON ((im.chat_id = c.id)));
  SQL
end

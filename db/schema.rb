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

ActiveRecord::Schema.define(version: 20200319153029) do

  # These are extensions that must be enabled in order to support this database
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

  create_table "admin_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.string "oclc_control_number_az"
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
  end

  create_table "bookkeeping_data_loads", force: :cascade do |t|
    t.string "table_name"
    t.string "earliest"
    t.string "latest"
  end

  create_table "borrowdirect_bibliographies", force: :cascade do |t|
    t.string "request_number", limit: 12
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
  end

  create_table "borrowdirect_call_numbers", force: :cascade do |t|
    t.string "request_number", limit: 12
    t.integer "holdings_seq"
    t.string "supplier_code", limit: 20
    t.string "call_number", limit: 256
    t.datetime "process_date"
    t.boolean "is_legacy", default: false, null: false
  end

  create_table "borrowdirect_exception_codes", force: :cascade do |t|
    t.string "exception_code", limit: 3, null: false
    t.string "exception_code_desc", limit: 64
    t.boolean "is_legacy", default: false, null: false
  end

  create_table "borrowdirect_institutions", force: :cascade do |t|
    t.integer "library_id", null: false
    t.string "library_symbol", limit: 25, null: false
    t.string "institution_name", limit: 100
    t.string "prime_post_zipcode", limit: 16
    t.decimal "weighting_factor", precision: 5, scale: 2
  end

  create_table "borrowdirect_min_ship_dates", force: :cascade do |t|
    t.string "request_number", limit: 12, null: false
    t.datetime "min_ship_date", null: false
    t.boolean "is_legacy", default: false, null: false
  end

  create_table "borrowdirect_patron_types", force: :cascade do |t|
    t.string "patron_type", limit: 1, null: false
    t.string "patron_type_desc", limit: 50
    t.boolean "is_legacy", default: false, null: false
  end

  create_table "borrowdirect_print_dates", force: :cascade do |t|
    t.string "request_number", limit: 12
    t.datetime "print_date"
    t.string "note", limit: 256
    t.datetime "process_date"
    t.integer "library_id"
    t.boolean "is_legacy", default: false, null: false
  end

  create_table "borrowdirect_ship_dates", force: :cascade do |t|
    t.string "request_number", limit: 12
    t.datetime "ship_date", null: false
    t.string "exception_code", limit: 3
    t.datetime "process_date"
    t.boolean "is_legacy", default: false, null: false
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

  create_table "gate_count_card_swipes", force: :cascade do |t|
    t.date "swipe_date"
    t.string "swipe_time"
    t.string "door_name"
    t.string "affiliation_desc"
    t.string "center_desc"
    t.string "dept_desc"
    t.string "usc_desc"
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

  create_table "marc_book_mods", force: :cascade do |t|
    t.string "title"
    t.string "name"
    t.string "name_date"
    t.string "role"
    t.string "type_of_resource"
    t.string "genre"
    t.string "origin_place_code"
    t.string "origin_place"
    t.string "origin_publisher"
    t.string "origin_date_issued"
    t.string "origin_issuance"
    t.string "language"
    t.string "physical_description_form"
    t.string "physical_description_extent"
    t.string "subject"
    t.string "classification"
    t.string "related_item_title"
    t.string "lccn_identifier"
    t.string "oclc_identifier"
    t.string "record_content_source"
    t.string "record_creation_date"
    t.string "record_change_date"
    t.string "record_identifier"
    t.string "record_origin"
  end

  create_table "ups_zones", force: :cascade do |t|
    t.string "from_prefix", null: false
    t.string "to_prefix", null: false
    t.integer "zone", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end

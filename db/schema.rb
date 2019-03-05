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

ActiveRecord::Schema.define(version: 20190214042906) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

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

  create_table "bookmarks", id: :serial, force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "user_type"
    t.string "document_id"
    t.string "document_type"
    t.binary "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["document_id"], name: "index_bookmarks_on_document_id"
    t.index ["user_id"], name: "index_bookmarks_on_user_id"
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

  create_table "checksum_audit_logs", force: :cascade do |t|
    t.string "file_set_id"
    t.string "file_id"
    t.string "checked_uri"
    t.string "expected_result"
    t.string "actual_result"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "passed"
    t.index ["checked_uri"], name: "index_checksum_audit_logs_on_checked_uri"
    t.index ["file_set_id", "file_id"], name: "by_file_set_id_and_file_id"
  end

  create_table "collection_branding_infos", force: :cascade do |t|
    t.string "collection_id"
    t.string "role"
    t.string "local_path"
    t.string "alt_text"
    t.string "target_url"
    t.integer "height"
    t.integer "width"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "collection_type_participants", force: :cascade do |t|
    t.bigint "hyrax_collection_type_id"
    t.string "agent_type"
    t.string "agent_id"
    t.string "access"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["hyrax_collection_type_id"], name: "hyrax_collection_type_id"
  end

  create_table "content_blocks", force: :cascade do |t|
    t.string "name"
    t.text "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "external_key"
  end

  create_table "curation_concerns_operations", force: :cascade do |t|
    t.string "status"
    t.string "operation_type"
    t.string "job_class"
    t.string "job_id"
    t.string "type"
    t.text "message"
    t.bigint "user_id"
    t.integer "parent_id"
    t.integer "lft", null: false
    t.integer "rgt", null: false
    t.integer "depth", default: 0, null: false
    t.integer "children_count", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["lft"], name: "index_curation_concerns_operations_on_lft"
    t.index ["parent_id"], name: "index_curation_concerns_operations_on_parent_id"
    t.index ["rgt"], name: "index_curation_concerns_operations_on_rgt"
    t.index ["user_id"], name: "index_curation_concerns_operations_on_user_id"
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

  create_table "featured_works", force: :cascade do |t|
    t.integer "order", default: 5
    t.string "work_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order"], name: "index_featured_works_on_order"
    t.index ["work_id"], name: "index_featured_works_on_work_id"
  end

  create_table "file_download_stats", force: :cascade do |t|
    t.datetime "date"
    t.integer "downloads"
    t.string "file_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.index ["file_id"], name: "index_file_download_stats_on_file_id"
    t.index ["user_id"], name: "index_file_download_stats_on_user_id"
  end

  create_table "file_view_stats", force: :cascade do |t|
    t.datetime "date"
    t.integer "views"
    t.string "file_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.index ["file_id"], name: "index_file_view_stats_on_file_id"
    t.index ["user_id"], name: "index_file_view_stats_on_user_id"
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

  create_table "hyrax_collection_types", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.string "machine_id"
    t.boolean "nestable", default: true, null: false
    t.boolean "discoverable", default: true, null: false
    t.boolean "sharable", default: true, null: false
    t.boolean "allow_multiple_membership", default: true, null: false
    t.boolean "require_membership", default: false, null: false
    t.boolean "assigns_workflow", default: false, null: false
    t.boolean "assigns_visibility", default: false, null: false
    t.boolean "share_applies_to_new_works", default: true, null: false
    t.boolean "brandable", default: true, null: false
    t.string "badge_color", default: "#663333"
    t.index ["machine_id"], name: "index_hyrax_collection_types_on_machine_id", unique: true
  end

  create_table "hyrax_features", force: :cascade do |t|
    t.string "key", null: false
    t.boolean "enabled", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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

  create_table "job_io_wrappers", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "uploaded_file_id"
    t.string "file_set_id"
    t.string "mime_type"
    t.string "original_name"
    t.string "path"
    t.string "relation"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["uploaded_file_id"], name: "index_job_io_wrappers_on_uploaded_file_id"
    t.index ["user_id"], name: "index_job_io_wrappers_on_user_id"
  end

  create_table "keyserver_audits", force: :cascade do |t|
    t.string "audit_id"
    t.integer "audit_server_id"
    t.string "audit_computer_id"
    t.string "audit_program_id"
    t.integer "audit_size"
    t.integer "audit_count"
    t.datetime "audit_first_seen"
    t.datetime "audit_last_seen"
    t.datetime "audit_last_used"
    t.string "audit_serial_number"
    t.string "audit_path"
  end

  create_table "keyserver_computer_divisions", force: :cascade do |t|
    t.integer "division_id"
    t.integer "division_server_id"
    t.string "division_name"
    t.string "division_color"
    t.string "division_notes"
    t.string "division_flags"
  end

  create_table "keyserver_computer_group_members", force: :cascade do |t|
    t.integer "member_id"
    t.integer "member_server_id"
    t.integer "member_computer_id"
    t.integer "member_group_id"
    t.string "member_acknowledged"
    t.string "member_last_used"
  end

  create_table "keyserver_computer_groups", force: :cascade do |t|
    t.integer "group_id"
    t.integer "group_server_id"
    t.string "group_num_members"
    t.string "group_max_members"
    t.string "group_notes"
    t.string "group_flags"
  end

  create_table "keyserver_computers", force: :cascade do |t|
    t.string "computer_id"
    t.integer "computer_server_id"
    t.string "computer_name"
    t.string "computer_user_name"
    t.string "computer_platform"
    t.string "computer_protocol"
    t.string "computer_address"
    t.string "computer_domain"
    t.string "computer_description"
    t.string "computer_virtual_host"
    t.string "computer_gmt_offset"
    t.string "computer_os_family"
    t.string "computer_os_type"
    t.string "computer_os_version"
    t.string "computer_os_release"
    t.date "computer_os_install_date"
    t.string "computer_os64_bit"
    t.string "computer_cpu_type"
    t.integer "computer_cpu_count"
    t.string "computer_cpu_clock"
    t.string "computer_cpu64_bit"
    t.string "computer_hyper_threading"
    t.string "computer_multicore"
    t.string "computer_capabilities"
    t.integer "computer_ram_size"
    t.string "computer_ram_type"
    t.string "computer_ram_array"
    t.integer "computer_disk_size"
    t.string "computer_free_space"
    t.string "computer_disk_manufacturer"
    t.string "computer_disk_model"
    t.string "computer_display_width"
    t.string "computer_display_height"
    t.string "computer_display_depth"
    t.string "computer_display_manufacturer"
    t.string "computer_display_model"
    t.string "computer_display_serial"
    t.string "computer_video_manufacturer"
    t.string "computer_video_model"
    t.integer "computer_vram_size"
    t.string "computer_mac_address"
    t.string "computer_mac_manufacturer"
    t.string "computer_mac_model"
    t.string "computer_wireless_address"
    t.string "computer_wireless_manufacturer"
    t.string "computer_wireless_model"
    t.string "computer_mac_array"
    t.string "computer_site"
    t.string "computer_oem_serial"
    t.string "computer_os_serial"
    t.string "computer_baseboard_serial"
    t.string "computer_system_serial"
    t.string "computer_manufacturer"
    t.string "computer_model"
    t.string "computer_bios_serial"
    t.string "computer_bios_model"
    t.string "computer_bios_version"
    t.string "computer_cdrom_present"
    t.string "computer_cdrom_writable"
    t.string "computer_cdrom_manufacturer"
    t.string "computer_cdrom_model"
    t.string "computer_dvd_present"
    t.string "computer_dvd_writable"
    t.string "computer_sound_manufacturer"
    t.string "computer_sound_model"
    t.string "computer_lease_expiration"
    t.string "computer_last_login"
    t.string "computer_last_audit"
    t.string "computer_base_audit"
    t.string "computer_client_version"
    t.string "computer_user_session"
    t.string "computer_acknowledged"
    t.string "computer_allowed"
    t.string "computer_audit"
    t.integer "computer_division_id"
    t.integer "computer_asset_id"
    t.string "computer_location"
    t.string "computer_owner"
    t.string "computer_confirmed"
    t.string "computer_confirmed_by"
    t.string "computer_notes"
    t.string "computer_flags"
  end

  create_table "keyserver_contracts", force: :cascade do |t|
    t.integer "contract_id"
    t.integer "contract_server_id"
    t.string "contract_name"
  end

  create_table "keyserver_hotfixes", force: :cascade do |t|
    t.string "hotfix_id"
    t.integer "hotfix_server_id"
    t.string "hotfix_stamp"
    t.string "hotfix_name"
    t.string "hotfix_version"
    t.string "hotfix_platform"
    t.string "hotfix_publisher"
    t.date "hotfix_create_date"
    t.string "hotfix_user_name"
    t.string "hotfix_computer_id"
    t.string "hotfix_notes"
    t.string "hotfix_flags"
  end

  create_table "keyserver_licensed_computers", force: :cascade do |t|
    t.string "licensee_id"
    t.integer "licensee_server_id"
    t.string "licensee_computer_id"
    t.string "licensee_policy_id"
    t.boolean "licensee_acknowledged"
    t.datetime "licensee_last_used"
    t.datetime "licensee_lease_date"
    t.datetime "licensee_lease_expiration"
  end

  create_table "keyserver_licensed_users", force: :cascade do |t|
    t.integer "licensee_id"
    t.integer "licensee_server_id"
    t.integer "licensee_user_id"
    t.integer "licensee_policy_id"
    t.string "licensee_acknowledged"
    t.string "licensee_last_used"
    t.date "licensee_lease_date"
    t.string "licensee_lease_expiration"
  end

  create_table "keyserver_locations", force: :cascade do |t|
    t.bigint "location_id"
    t.integer "location_server_id"
    t.string "location_protocol"
    t.string "location_name"
    t.string "location_range_begin"
    t.string "location_range_end"
    t.string "location_allowed"
    t.string "location_notes"
    t.string "location_flags"
  end

  create_table "keyserver_policies", force: :cascade do |t|
    t.string "policy_id"
    t.integer "policy_server_id"
    t.integer "policy_ref_num"
    t.string "policy_name"
    t.string "policy_action"
    t.string "policy_metric"
    t.integer "policy_maximum"
    t.string "policy_lease_time"
    t.string "policy_status"
    t.datetime "policy_expiration"
    t.string "policy_options"
    t.integer "policy_folder_id"
    t.integer "policy_contract_id"
    t.string "policy_cost_center"
    t.string "policy_message"
    t.string "policy_notes"
  end

  create_table "keyserver_policy_folders", force: :cascade do |t|
    t.integer "polfolder_id"
    t.integer "polfolder_server_id"
    t.string "polfolder_name"
    t.string "polfolder_color"
    t.string "polfolder_notes"
    t.string "polfolder_flags"
  end

  create_table "keyserver_policy_products", force: :cascade do |t|
    t.string "polprod_id"
    t.integer "polprod_server_id"
    t.string "polprod_policy_id"
    t.string "polprod_product_id"
    t.integer "polprod_position"
    t.string "polprod_flags"
  end

  create_table "keyserver_product_components", force: :cascade do |t|
    t.string "component_id"
    t.integer "component_server_id"
    t.string "component_product_id"
    t.string "component_program_variant"
    t.string "component_utility"
    t.string "component_position"
    t.string "component_flags"
  end

  create_table "keyserver_product_folders", force: :cascade do |t|
    t.integer "prodfolder_id"
    t.integer "prodfolder_server_id"
    t.string "prodfolder_name"
    t.string "prodfolder_color"
    t.string "prodfolder_notes"
    t.string "prodfolder_flags"
  end

  create_table "keyserver_products", force: :cascade do |t|
    t.string "product_id"
    t.integer "product_server_id"
    t.string "product_name"
    t.string "product_version"
    t.string "product_platform"
    t.date "product_release_date"
    t.integer "product_folder_id"
    t.string "product_upgrade_id"
    t.string "product_status"
    t.string "product_tracked"
    t.string "product_publisher"
    t.string "product_category"
    t.string "product_contact"
    t.string "product_contact_address"
    t.string "product_defined_by"
    t.string "product_notes"
    t.string "product_flags"
  end

  create_table "keyserver_program_folders", force: :cascade do |t|
    t.integer "folder_id"
    t.integer "folder_server_id"
    t.string "folder_name"
    t.string "folder_color"
    t.string "folder_notes"
    t.string "folder_flags"
  end

  create_table "keyserver_programs", force: :cascade do |t|
    t.string "program_id"
    t.integer "program_server_id"
    t.string "program_variant"
    t.string "program_char_stamp"
    t.string "program_name"
    t.string "program_variant_name"
    t.string "program_variant_version"
    t.string "program_ai_version"
    t.string "program_version_mask"
    t.string "program_version"
    t.string "program_platform"
    t.string "program_publisher"
    t.string "program_path"
    t.string "program_file_name"
    t.string "program_keyed"
    t.string "program_status"
    t.string "program_acknowledged"
    t.string "program_audit"
    t.integer "program_folder_id"
    t.string "program_launch_seen"
    t.string "program_disc_method"
    t.datetime "program_discovered"
    t.datetime "program_create_date"
    t.string "program_user_name"
    t.string "program_computer_id"
    t.string "program_notes"
    t.string "program_flags"
  end

  create_table "keyserver_purchase_allocations", force: :cascade do |t|
    t.integer "allocation_id"
    t.integer "allocation_server_id"
    t.integer "allocation_purchase_id"
    t.integer "allocation_upgrade_id"
    t.string "allocation_quantity"
    t.string "allocation_flags"
  end

  create_table "keyserver_purchase_codes", force: :cascade do |t|
    t.integer "code_id"
    t.integer "code_server_id"
    t.integer "code_purchase_id"
    t.string "code_value"
  end

  create_table "keyserver_purchase_documents", force: :cascade do |t|
    t.integer "document_id"
    t.integer "document_server_id"
    t.integer "document_purchase_id"
    t.string "document_name"
    t.string "document_url"
    t.date "document_date_added"
  end

  create_table "keyserver_purchase_folders", force: :cascade do |t|
    t.integer "purchfolder_id"
    t.integer "purchfolder_server_id"
    t.string "purchfolder_name"
    t.string "purchfolder_color"
    t.string "purchfolder_notes"
    t.string "purchfolder_flags"
  end

  create_table "keyserver_purchase_items", force: :cascade do |t|
    t.string "purchase_id"
    t.integer "purchase_server_id"
    t.string "purchase_order_id"
    t.string "purchase_name"
    t.string "purchase_status"
    t.string "purchase_type"
    t.string "purchase_entitlement_type"
    t.string "purchase_metric"
    t.integer "purchase_folder_id"
    t.string "purchase_entitlements_per_package"
    t.date "purchase_start_date"
    t.date "purchase_end_date"
    t.date "purchase_renew_date"
    t.string "purchase_currency"
    t.string "purchase_extended_cost"
    t.string "purchase_converted_cost"
    t.string "purchase_unit_msrp"
    t.string "purchase_unit_price"
    t.string "purchase_product_id"
    t.string "purchase_effective_product_id"
    t.string "purchase_invoice"
    t.integer "purchase_division_id"
    t.integer "purchase_contract_id"
    t.string "purchase_group"
    t.string "purchase_site"
    t.string "purchase_cost_center"
    t.string "purchase_reseller_sku"
    t.string "purchase_manufacturer_sku"
    t.integer "purchase_external_id"
    t.string "purchase_location"
    t.string "purchase_reference"
    t.string "purchase_conditions"
    t.string "purchase_description"
    t.string "purchase_notes"
    t.string "purchase_flags"
  end

  create_table "keyserver_purchase_orders", force: :cascade do |t|
    t.string "order_id"
    t.integer "order_server_id"
    t.date "order_date"
    t.integer "order_folder_id"
    t.string "order_recipient"
    t.string "order_reseller"
    t.string "order_reseller_po"
    t.string "order_notes"
    t.string "order_flags"
  end

  create_table "keyserver_purchase_supports", force: :cascade do |t|
    t.integer "support_id"
    t.integer "support_server_id"
    t.integer "support_purchase_id"
    t.integer "support_product_id"
  end

  create_table "keyserver_servers", force: :cascade do |t|
    t.integer "server_id"
    t.string "server_type"
    t.string "server_name"
    t.string "server_computer"
    t.string "server_serial_number"
    t.string "server_version"
    t.string "server_start_time"
    t.string "server_gmt_offset"
    t.string "server_time_zone"
    t.string "server_seats"
    t.string "server_full_clients"
    t.string "server_floating_sessions"
    t.string "server_floating_ratio"
    t.string "server_licenses_in_use"
    t.string "server_licenses_in_queue"
  end

  create_table "keyserver_user_folders", force: :cascade do |t|
    t.integer "usrfolder_id"
    t.integer "usrfolder_server_id"
    t.string "usrfolder_name"
    t.string "usrfolder_color"
    t.string "usrfolder_notes"
    t.string "usrfolder_flags"
  end

  create_table "keyserver_users", force: :cascade do |t|
    t.string "user_id"
    t.integer "user_server_id"
    t.datetime "user_last_login"
    t.string "user_computer_id"
    t.integer "user_folder_id"
    t.integer "user_external_id"
    t.string "user_notes"
    t.string "user_flags"
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

  create_table "mailboxer_conversation_opt_outs", id: :serial, force: :cascade do |t|
    t.string "unsubscriber_type"
    t.integer "unsubscriber_id"
    t.integer "conversation_id"
    t.index ["conversation_id"], name: "index_mailboxer_conversation_opt_outs_on_conversation_id"
    t.index ["unsubscriber_id", "unsubscriber_type"], name: "index_mailboxer_conversation_opt_outs_on_unsubscriber_id_type"
  end

  create_table "mailboxer_conversations", id: :serial, force: :cascade do |t|
    t.string "subject", default: ""
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "mailboxer_notifications", id: :serial, force: :cascade do |t|
    t.string "type"
    t.text "body"
    t.string "subject", default: ""
    t.string "sender_type"
    t.integer "sender_id"
    t.integer "conversation_id"
    t.boolean "draft", default: false
    t.string "notification_code"
    t.string "notified_object_type"
    t.integer "notified_object_id"
    t.string "attachment"
    t.datetime "updated_at", null: false
    t.datetime "created_at", null: false
    t.boolean "global", default: false
    t.datetime "expires"
    t.index ["conversation_id"], name: "index_mailboxer_notifications_on_conversation_id"
    t.index ["notified_object_id", "notified_object_type"], name: "index_mailboxer_notifications_on_notified_object_id_and_type"
    t.index ["notified_object_type", "notified_object_id"], name: "mailboxer_notifications_notified_object"
    t.index ["sender_id", "sender_type"], name: "index_mailboxer_notifications_on_sender_id_and_sender_type"
    t.index ["type"], name: "index_mailboxer_notifications_on_type"
  end

  create_table "mailboxer_receipts", id: :serial, force: :cascade do |t|
    t.string "receiver_type"
    t.integer "receiver_id"
    t.integer "notification_id", null: false
    t.boolean "is_read", default: false
    t.boolean "trashed", default: false
    t.boolean "deleted", default: false
    t.string "mailbox_type", limit: 25
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_delivered", default: false
    t.string "delivery_method"
    t.string "message_id"
    t.index ["notification_id"], name: "index_mailboxer_receipts_on_notification_id"
    t.index ["receiver_id", "receiver_type"], name: "index_mailboxer_receipts_on_receiver_id_and_receiver_type"
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
    t.string "notes", limit: 1000
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

  create_table "minter_states", id: :serial, force: :cascade do |t|
    t.string "namespace", default: "default", null: false
    t.string "template", null: false
    t.text "counters"
    t.bigint "seq", default: 0
    t.binary "rand"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["namespace"], name: "index_minter_states_on_namespace", unique: true
  end

  create_table "orm_resources", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.jsonb "metadata", default: {}, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "internal_resource"
    t.integer "lock_version"
    t.index "metadata jsonb_path_ops", name: "index_orm_resources_on_metadata_jsonb_path_ops", using: :gin
    t.index ["internal_resource"], name: "index_orm_resources_on_internal_resource"
    t.index ["metadata"], name: "index_orm_resources_on_metadata", using: :gin
    t.index ["updated_at"], name: "index_orm_resources_on_updated_at"
  end

  create_table "permission_template_accesses", force: :cascade do |t|
    t.bigint "permission_template_id"
    t.string "agent_type"
    t.string "agent_id"
    t.string "access"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["permission_template_id", "agent_id", "agent_type", "access"], name: "uk_permission_template_accesses", unique: true
    t.index ["permission_template_id"], name: "index_permission_template_accesses_on_permission_template_id"
  end

  create_table "permission_templates", force: :cascade do |t|
    t.string "source_id"
    t.string "visibility"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "release_date"
    t.string "release_period"
    t.index ["source_id"], name: "index_permission_templates_on_source_id", unique: true
  end

  create_table "proxy_deposit_requests", force: :cascade do |t|
    t.string "work_id", null: false
    t.bigint "sending_user_id", null: false
    t.bigint "receiving_user_id", null: false
    t.datetime "fulfillment_date"
    t.string "status", default: "pending", null: false
    t.text "sender_comment"
    t.text "receiver_comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["receiving_user_id"], name: "index_proxy_deposit_requests_on_receiving_user_id"
    t.index ["sending_user_id"], name: "index_proxy_deposit_requests_on_sending_user_id"
  end

  create_table "proxy_deposit_rights", force: :cascade do |t|
    t.bigint "grantor_id"
    t.bigint "grantee_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["grantee_id"], name: "index_proxy_deposit_rights_on_grantee_id"
    t.index ["grantor_id"], name: "index_proxy_deposit_rights_on_grantor_id"
  end

  create_table "qa_local_authorities", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_qa_local_authorities_on_name", unique: true
  end

  create_table "qa_local_authority_entries", force: :cascade do |t|
    t.bigint "local_authority_id"
    t.string "label"
    t.string "uri"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["local_authority_id"], name: "index_qa_local_authority_entries_on_local_authority_id"
    t.index ["uri"], name: "index_qa_local_authority_entries_on_uri", unique: true
  end

  create_table "searches", id: :serial, force: :cascade do |t|
    t.binary "query_params"
    t.integer "user_id"
    t.string "user_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_searches_on_user_id"
  end

  create_table "single_use_links", force: :cascade do |t|
    t.string "download_key"
    t.string "path"
    t.string "item_id"
    t.datetime "expires"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sipity_agents", force: :cascade do |t|
    t.string "proxy_for_id", null: false
    t.string "proxy_for_type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["proxy_for_id", "proxy_for_type"], name: "sipity_agents_proxy_for", unique: true
  end

  create_table "sipity_comments", force: :cascade do |t|
    t.integer "entity_id", null: false
    t.integer "agent_id", null: false
    t.text "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["agent_id"], name: "index_sipity_comments_on_agent_id"
    t.index ["created_at"], name: "index_sipity_comments_on_created_at"
    t.index ["entity_id"], name: "index_sipity_comments_on_entity_id"
  end

  create_table "sipity_entities", force: :cascade do |t|
    t.string "proxy_for_global_id", null: false
    t.integer "workflow_id", null: false
    t.integer "workflow_state_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["proxy_for_global_id"], name: "sipity_entities_proxy_for_global_id", unique: true
    t.index ["workflow_id"], name: "index_sipity_entities_on_workflow_id"
    t.index ["workflow_state_id"], name: "index_sipity_entities_on_workflow_state_id"
  end

  create_table "sipity_entity_specific_responsibilities", force: :cascade do |t|
    t.integer "workflow_role_id", null: false
    t.string "entity_id", null: false
    t.integer "agent_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["agent_id"], name: "sipity_entity_specific_responsibilities_agent"
    t.index ["entity_id"], name: "sipity_entity_specific_responsibilities_entity"
    t.index ["workflow_role_id", "entity_id", "agent_id"], name: "sipity_entity_specific_responsibilities_aggregate", unique: true
    t.index ["workflow_role_id"], name: "sipity_entity_specific_responsibilities_role"
  end

  create_table "sipity_notifiable_contexts", force: :cascade do |t|
    t.integer "scope_for_notification_id", null: false
    t.string "scope_for_notification_type", null: false
    t.string "reason_for_notification", null: false
    t.integer "notification_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["notification_id"], name: "sipity_notifiable_contexts_notification_id"
    t.index ["scope_for_notification_id", "scope_for_notification_type", "reason_for_notification", "notification_id"], name: "sipity_notifiable_contexts_concern_surrogate", unique: true
    t.index ["scope_for_notification_id", "scope_for_notification_type", "reason_for_notification"], name: "sipity_notifiable_contexts_concern_context"
    t.index ["scope_for_notification_id", "scope_for_notification_type"], name: "sipity_notifiable_contexts_concern"
  end

  create_table "sipity_notification_recipients", force: :cascade do |t|
    t.integer "notification_id", null: false
    t.integer "role_id", null: false
    t.string "recipient_strategy", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["notification_id", "role_id", "recipient_strategy"], name: "sipity_notifications_recipients_surrogate"
    t.index ["notification_id"], name: "sipity_notification_recipients_notification"
    t.index ["recipient_strategy"], name: "sipity_notification_recipients_recipient_strategy"
    t.index ["role_id"], name: "sipity_notification_recipients_role"
  end

  create_table "sipity_notifications", force: :cascade do |t|
    t.string "name", null: false
    t.string "notification_type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_sipity_notifications_on_name", unique: true
    t.index ["notification_type"], name: "index_sipity_notifications_on_notification_type"
  end

  create_table "sipity_roles", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_sipity_roles_on_name", unique: true
  end

  create_table "sipity_workflow_actions", force: :cascade do |t|
    t.integer "workflow_id", null: false
    t.integer "resulting_workflow_state_id"
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["resulting_workflow_state_id"], name: "sipity_workflow_actions_resulting_workflow_state"
    t.index ["workflow_id", "name"], name: "sipity_workflow_actions_aggregate", unique: true
    t.index ["workflow_id"], name: "sipity_workflow_actions_workflow"
  end

  create_table "sipity_workflow_methods", force: :cascade do |t|
    t.string "service_name", null: false
    t.integer "weight", null: false
    t.integer "workflow_action_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["workflow_action_id"], name: "index_sipity_workflow_methods_on_workflow_action_id"
  end

  create_table "sipity_workflow_responsibilities", force: :cascade do |t|
    t.integer "agent_id", null: false
    t.integer "workflow_role_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["agent_id", "workflow_role_id"], name: "sipity_workflow_responsibilities_aggregate", unique: true
  end

  create_table "sipity_workflow_roles", force: :cascade do |t|
    t.integer "workflow_id", null: false
    t.integer "role_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["workflow_id", "role_id"], name: "sipity_workflow_roles_aggregate", unique: true
  end

  create_table "sipity_workflow_state_action_permissions", force: :cascade do |t|
    t.integer "workflow_role_id", null: false
    t.integer "workflow_state_action_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["workflow_role_id", "workflow_state_action_id"], name: "sipity_workflow_state_action_permissions_aggregate", unique: true
  end

  create_table "sipity_workflow_state_actions", force: :cascade do |t|
    t.integer "originating_workflow_state_id", null: false
    t.integer "workflow_action_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["originating_workflow_state_id", "workflow_action_id"], name: "sipity_workflow_state_actions_aggregate", unique: true
  end

  create_table "sipity_workflow_states", force: :cascade do |t|
    t.integer "workflow_id", null: false
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_sipity_workflow_states_on_name"
    t.index ["workflow_id", "name"], name: "sipity_type_state_aggregate", unique: true
  end

  create_table "sipity_workflows", force: :cascade do |t|
    t.string "name", null: false
    t.string "label"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "permission_template_id"
    t.boolean "active"
    t.boolean "allows_access_grant"
    t.index ["permission_template_id", "name"], name: "index_sipity_workflows_on_permission_template_and_name", unique: true
  end

  create_table "tinymce_assets", force: :cascade do |t|
    t.string "file"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "trophies", force: :cascade do |t|
    t.integer "user_id"
    t.string "work_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "uploaded_files", force: :cascade do |t|
    t.string "file"
    t.bigint "user_id"
    t.string "file_set_uri"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["file_set_uri"], name: "index_uploaded_files_on_file_set_uri"
    t.index ["user_id"], name: "index_uploaded_files_on_user_id"
  end

  create_table "ups_zones", force: :cascade do |t|
    t.string "from_prefix", null: false
    t.string "to_prefix", null: false
    t.integer "zone", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_stats", force: :cascade do |t|
    t.integer "user_id"
    t.datetime "date"
    t.integer "file_views"
    t.integer "file_downloads"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "work_views"
    t.index ["user_id"], name: "index_user_stats_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "guest", default: false
    t.string "facebook_handle"
    t.string "twitter_handle"
    t.string "googleplus_handle"
    t.string "display_name"
    t.string "address"
    t.string "admin_area"
    t.string "department"
    t.string "title"
    t.string "office"
    t.string "chat_id"
    t.string "website"
    t.string "affiliation"
    t.string "telephone"
    t.string "avatar_file_name"
    t.string "avatar_content_type"
    t.integer "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string "linkedin_handle"
    t.string "orcid"
    t.string "arkivo_token"
    t.string "arkivo_subscription"
    t.binary "zotero_token"
    t.string "zotero_userid"
    t.string "preferred_locale"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "version_committers", force: :cascade do |t|
    t.string "obj_id"
    t.string "datastream_id"
    t.string "version_id"
    t.string "committer_login"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "work_view_stats", force: :cascade do |t|
    t.datetime "date"
    t.integer "work_views"
    t.string "work_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.index ["user_id"], name: "index_work_view_stats_on_user_id"
    t.index ["work_id"], name: "index_work_view_stats_on_work_id"
  end

  add_foreign_key "collection_type_participants", "hyrax_collection_types"
  add_foreign_key "curation_concerns_operations", "users"
  add_foreign_key "mailboxer_conversation_opt_outs", "mailboxer_conversations", column: "conversation_id", name: "mb_opt_outs_on_conversations_id"
  add_foreign_key "mailboxer_notifications", "mailboxer_conversations", column: "conversation_id", name: "notifications_on_conversation_id"
  add_foreign_key "mailboxer_receipts", "mailboxer_notifications", column: "notification_id", name: "receipts_on_notification_id"
  add_foreign_key "permission_template_accesses", "permission_templates"
  add_foreign_key "qa_local_authority_entries", "qa_local_authorities", column: "local_authority_id"
  add_foreign_key "uploaded_files", "users"
end

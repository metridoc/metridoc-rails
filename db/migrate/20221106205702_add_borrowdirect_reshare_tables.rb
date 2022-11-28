class AddBorrowdirectReshareTables < ActiveRecord::Migration[5.2]
  def change
    create_table "bd_reshare_borrowing_turnarounds", force: :cascade do |t|
      t.string "borrower"
      t.string "request_id"
      t.datetime "request_date"
      t.datetime "shipped_date"
      t.datetime "received_date"
      t.decimal "time_to_ship"
      t.decimal "time_to_receipt"
      t.decimal "total_time"
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
      t.datetime "last_updated"
      t.index ["origin", "de_id"], name: "bd_directory_entry_index", unique: true
    end

    create_table "bd_reshare_lending_turnarounds", force: :cascade do |t|
      t.string "lender"
      t.string "request_id"
      t.datetime "request_date"
      t.datetime "filled_date"
      t.datetime "shipped_date"
      t.datetime "received_date"
      t.decimal "time_to_fill"
      t.decimal "time_to_ship"
      t.decimal "time_to_receipt"
      t.decimal "total_time"
      t.index ["lender", "request_id"], name: "bd_lending_turnaround_index", unique: true
    end

    create_table "bd_reshare_patron_request_audits", force: :cascade do |t|
      t.datetime "last_updated"
      t.string "origin"
      t.string "pra_id"
      t.string "pra_version"
      t.datetime "pra_date_created"
      t.string "pra_patron_request_fk"
      t.string "pra_from_status_fk"
      t.string "pra_to_status_fk"
      t.string "pra_message"
      t.index ["pra_id"], name: "bd_patron_request_audit_index", unique: true
    end

    create_table "bd_reshare_patron_request_rota", force: :cascade do |t|
      t.datetime "last_updated"
      t.string "origin"
      t.string "prr_id"
      t.string "prr_version"
      t.datetime "prr_date_created"
      t.datetime "prr_last_updated"
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
      t.datetime "pr_date_created"
      t.string "pr_pub_date"
      t.datetime "last_updated"
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
      t.datetime "pr_due_date_from_lms"
      t.datetime "pr_parsed_due_date_lms"
      t.datetime "pr_due_date_rs"
      t.datetime "pr_parsed_due_date_rs"
      t.boolean "pr_overdue"
      t.index ["pr_id"], name: "bd_patron_requests_index", unique: true
    end

    create_table "bd_reshare_status", force: :cascade do |t|
      t.datetime "last_updated"
      t.string "origin"
      t.string "st_id"
      t.string "st_version"
      t.string "st_code"
      t.index ["st_id"], name: "bd_status_index", unique: true
    end

    create_table "bd_reshare_symbols", force: :cascade do |t|
      t.datetime "last_updated"
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
      t.datetime "date_created"
      t.datetime "borrower_last_updated"
      t.datetime "lender_last_updated"
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
      t.index ["borrower_id", "lender_id"], name: "bd_transaction_index", unique: true
    end

  end
end

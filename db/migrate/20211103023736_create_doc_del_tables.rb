class CreateDocDelTables < ActiveRecord::Migration[5.2]
  def change

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

  end
end

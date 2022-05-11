class ReshareTables2 < ActiveRecord::Migration[5.2]
  def change
    create_table :reshare_stat_reqs do |t|
      t.string   :str_supplier 
      t.string   :str_supplier_nice_name
      t.string   :str_hrid
      t.string   :str_title
      t.string   :str_call_number
      t.string   :str_barcode
      t.string   :str_requester
      t.string   :str_requester_nice_name
      t.datetime :str_date_created
      t.string   :str_id
    end

    create_table :reshare_stat_assis do |t|
      t.string   :sta_supplier
      t.datetime :sta_date_created
      t.string   :sta_req_id
      t.string   :sta_from_status
      t.string   :sta_to_status
    end

    create_table :reshare_stat_fills do |t|
      t.string   :stf_supplier
      t.datetime :stf_date_created
      t.string   :stf_req_id
      t.string   :stf_from_status
      t.string   :stf_to_status
    end

    create_table :reshare_stat_ships do |t|
      t.string   :sts_supplier
      t.datetime :sts_date_created
      t.string   :sts_req_id
      t.string   :sts_from_status
      t.string   :sts_to_status
    end

    create_table :reshare_stat_recs do |t|
      t.string   :stre_supplier
      t.datetime :stre_date_created
      t.string   :stre_req_id
      t.string   :stre_from_status
      t.string   :stre_to_status
    end

    create_table :reshare_sup_tat_stats do |t|
      t.string   :stst_supplier
      t.datetime :stst_date_created
      t.string   :stst_req_id
      t.string   :stst_from_status
      t.string   :stst_to_status
      t.string   :stst_message
    end

  end
end

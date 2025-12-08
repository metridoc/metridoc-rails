class CreateCaiasoftTables < ActiveRecord::Migration[7.1]
  def change
    create_table :caiasoft_circulation_metrics do |t|
      t.string :item_retrieved
      t.string :item_collection
      t.string :job_type
      t.string :circulation_stop
      t.string :circulation_location
      t.string :job
      t.datetime :retrieval_date
      t.integer :page_count
      t.string :requestor
      t.string :details
      t.string :api_feed
      t.string :request_id
      t.string :item_title
      t.string :item_call_number

      t.timestamps
    end

    create_table :caiasoft_retrievalinfo do |t|
      t.string :barcode
      t.string :collection
      t.datetime :retrieval_date
      t.string :retrieval_type

      t.timestamps
    end

    create_table :caiasoft_deaccessioninfo do |t|
      t.string :barcode
      t.string :collection
      t.string :item_id
      t.string :bib_id
      t.string :pid
      t.datetime :deaccession_date
      t.string :deaccession_type

      t.timestamps
    end

    create_table :caiasoft_circstopout do |t|
      t.string :barcode
      t.string :circulation_stop
      t.datetime :retrieval_date
      t.integer :days_outstanding

      t.timestamps
    end

    create_table :caiasoft_circstoplist do |t|
      t.string :stop_code
      t.string :stop_name
      t.string :stop_location
      t.string :stop_status
      t.string :delivery_pyr
      t.string :delivery_ert
      t.string :delivery_rrr
      t.string :delivery_shp

      t.timestamps
    end

    create_table :caiasoft_accessioninfo do |t|
      t.string :barcode
      t.string :collection
      t.string :material
      t.string :title
      t.string :volume
      t.string :call_number
      t.string :item_id
      t.string :bib_id
      t.string :pid
      t.datetime :accession_date
      t.string :accession_type

      t.timestamps
    end
  end
end

class ImportBorrrowdirect < ActiveRecord::Migration[5.1]
  def change
    create_table :borrowdirect_bibliographies do |t|
      t.string :request_number , limit: 12
      t.string :author , limit: 300
      t.string :title , limit: 400
      t.string :publisher , limit: 256
      t.string :publication_place , limit: 256
      t.string :publication_year , limit: 4
      t.string :edition , limit: 24
      t.string :lccn , limit: 32
      t.string :isbn , limit: 24
      t.string :isbn_2 , limit: 24
      t.datetime :request_date 
      t.datetime :process_date 
      t.string :pickup_location , limit: 64
      t.integer :borrower 
      t.integer :lender 
      t.string :supplier_code , limit: 20
      t.string :call_number , limit: 256
      t.bigint :oclc 
      t.string :oclc_text , limit: 25
      t.string :local_item_found , limit: 1
      t.string :lccn, limit: 50
    end

    create_table :borrowdirect_call_numbers do |t|
      t.string :request_number , limit: 12
      t.integer :holdings_seq 
      t.string :supplier_code , limit: 20
      t.string :call_number , limit: 256
      t.datetime :process_date 
    end

    create_table :borrowdirect_exception_codes do |t|
      t.string :exception_code , limit: 3, null: false
      t.string :exception_code_desc , limit: 64
    end

    create_table :borrowdirect_institutions do |t|
      t.string :catalog_code , limit: 1, null: false
      t.string :institution , limit: 64, null: false
      t.integer :library_id
    end

    create_table :borrowdirect_min_ship_dates do |t|
      t.string :request_number , limit: 12, null: false
      t.timestamp :min_ship_date , null: false
    end

    create_table :borrowdirect_patron_types do |t|
      t.string :patron_type , limit: 1, null: false
      t.string :patron_type_desc , limit: 50
    end

    create_table :borrowdirect_print_dates do |t|
      t.string :request_number , limit: 12
      t.datetime :print_date 
      t.string :note , limit: 256
      t.datetime :process_date 
      t.integer :library_id 
    end

    create_table :borrowdirect_ship_dates do |t|
      t.string :request_number , limit: 12
      t.datetime :ship_date, null: false
      t.string :exception_code , limit: 3
      t.datetime :process_date 
    end

  end
end

class ImportBorrrowdirect < ActiveRecord::Migration[5.2]
  def change
    create_table :bd_bibliographies do |t|
      t.string :request_number , limit: 12
      t.string :patron_id , limit: 20
      t.string :patron_type , limit: 1
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
      t.timestamp :load_time , null: false
      t.integer :oclc 
      t.string :oclc_text , limit: 25
      t.integer :bibliography_id , limit: 8, null: false
      t.integer :version , limit: 8, null: false
      t.string :publication_date , limit: 255
      t.string :local_item_found , limit: 1
    end

    create_table :bd_call_numbers do |t|
      t.string :request_number , limit: 12
      t.integer :holdings_seq 
      t.string :supplier_code , limit: 20
      t.string :call_number , limit: 256
      t.datetime :process_date 
      t.timestamp :load_time , null: false
      t.integer :call_number_id , limit: 8, null: false
      t.integer :version , limit: 8, null: false
    end

    create_table :bd_exception_codes do |t|
      t.string :exception_code , limit: 3, null: false
      t.string :exception_code_desc , limit: 64
      t.integer :bd_exception_code_id , null: false
      t.integer :version , limit: 8, null: false
    end

    create_table :bd_institutions do |t|
      t.string :catalog_code , limit: 1, null: false
      t.string :institution , limit: 64, null: false
      t.integer :library_id , null: false
      t.integer :version , limit: 8, null: false
      t.integer :bd_institution_id , limit: 8, null: false
    end

    create_table :bd_min_ship_dates do |t|
      t.string :request_number , limit: 12, null: false
      t.timestamp :min_ship_date , null: false
    end

    create_table :bd_patron_types do |t|
      t.string :patron_type , limit: 1, null: false
      t.string :patron_type_desc , limit: 50
      t.integer :bd_patron_type_id , null: false
    end

    create_table :bd_print_dates do |t|
      t.string :request_number , limit: 12
      t.datetime :print_date 
      t.string :note , limit: 256
      t.datetime :process_date 
      t.integer :print_date_id , limit: 8, null: false
      t.timestamp :load_time , null: false
      t.integer :library_id 
      t.integer :version , limit: 8, null: false
    end

    create_table :bd_report_distributions do |t|
      t.string :email_addr , limit: 32, null: false
      t.integer :institution_id , null: false
      t.integer :bd_report_distribution_id , limit: 8, null: false
      t.integer :version , limit: 8, null: false
      t.string :library_id , limit: 255, null: false
    end

    create_table :bd_report_distribution_tmps do |t|
      t.string :email_addr , limit: 32, null: false
      t.integer :institution_id , null: false
      t.integer :bd_report_distribution_tmp_id , limit: 8, null: false
      t.integer :version , limit: 8, null: false
      t.string :library_id , limit: 255, null: false
    end

    create_table :bd_ship_dates do |t|
      t.string :request_number , limit: 12
      t.string :ship_date , limit: 24, null: false
      t.string :exception_code , limit: 3
      t.datetime :process_date 
      t.integer :ship_date_id , limit: 8, null: false
      t.timestamp :load_time , null: false
      t.integer :version , limit: 8, null: false
    end

  end
end

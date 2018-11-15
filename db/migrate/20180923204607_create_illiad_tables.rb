class CreateIlliadTables < ActiveRecord::Migration[5.1]
  def change

    create_table :institutions do |t|
      t.string :name, null: false
      t.string :code, null: false
      t.string :zip_code
      t.timestamps null: false
    end

    create_table :illiad_borrowings do |t|
      t.belongs_to :institution, null: false
      t.string :request_type , limit: 255, null: false
      t.datetime :transaction_date , null: false
      t.integer :transaction_number , limit: 8, null: false
      t.string :transaction_status , limit: 255, null: false
      t.timestamps null: false
    end

    create_table :illiad_groups do |t|
      t.belongs_to :institution, null: false
      t.string :group_name , limit: 255, null: false
      t.integer :group_no , null: false
      t.timestamps null: false
    end

    create_table :illiad_lender_groups do |t|
      t.belongs_to :institution, null: false
      t.integer :demographic 
      t.integer :group_no , null: false
      t.string :lender_code , limit: 255, null: false
      t.timestamps null: false
    end

    create_table :illiad_lender_infos do |t|
      t.belongs_to :institution, null: false
      t.string :address , limit: 328
      t.string :billing_category , limit: 255
      t.string :lender_code , limit: 255, null: false
      t.string :library_name , limit: 255
      t.integer :address_number
      t.string  :nvtgc , limit: 255
      t.timestamps null: false
    end

    create_table :illiad_lendings do |t|
      t.belongs_to :institution, null: false
      t.string :request_type , limit: 255, null: false
      t.string :status , limit: 255, null: false
      t.datetime :transaction_date , null: false
      t.integer :transaction_number , limit: 8, null: false
      t.timestamps null: false
    end

    create_table :illiad_lending_trackings do |t|
      t.belongs_to :institution, null: false
      t.datetime :arrival_date 
      t.datetime :completion_date 
      t.string :completion_status , limit: 255
      t.string :request_type , limit: 255, null: false
      t.integer :transaction_number , limit: 8, null: false
      t.float :turnaround 
      t.timestamps null: false
    end

    create_table :illiad_reference_numbers do |t|
      t.belongs_to :institution, null: false
      t.string :oclc , limit: 255
      t.string :ref_number , limit: 255
      t.string :ref_type , limit: 255
      t.integer :transaction_number , limit: 8, null: false
      t.timestamps null: false
    end

    create_table :illiad_trackings do |t|
      t.belongs_to :institution, null: false
      t.datetime :order_date 
      t.string :process_type , limit: 255, null: false
      t.datetime :receive_date 
      t.datetime :request_date 
      t.string :request_type , limit: 255, null: false
      t.datetime :ship_date 
      t.integer :transaction_number , limit: 8, null: false
      t.float :turnaround_req_rec 
      t.float :turnaround_req_shp 
      t.float :turnaround_shp_rec 
      t.boolean :turnarounds_processed , null: false
      t.timestamps null: false
    end

    create_table :illiad_transactions do |t|
      t.belongs_to :institution, null: false
      t.string :billing_amount , limit: 255
      t.string :call_number , limit: 255
      t.string :cited_in , limit: 10000
      t.string :esp_number , limit: 255
      t.string :ifm_cost , limit: 255
      t.string :in_process_date , limit: 255
      t.string :issn , limit: 255
      t.string :lender_codes , limit: 255
      t.string :lending_library , limit: 255
      t.string :loan_author , limit: 255
      t.string :loan_date , limit: 255
      t.string :loan_edition , limit: 255
      t.string :loan_location , limit: 255
      t.string :loan_publisher , limit: 255
      t.string :loan_title , limit: 255
      t.string :location , limit: 255
      t.string :photo_article_author , limit: 255
      t.string :photo_article_title , limit: 255
      t.string :photo_journal_inclusive_pages , limit: 255
      t.string :photo_journal_issue , limit: 255
      t.string :photo_journal_month , limit: 255
      t.string :photo_journal_title , limit: 255
      t.string :photo_journal_volume , limit: 255
      t.string :photo_journal_year , limit: 255
      t.string :process_type , limit: 255
      t.string :reason_for_cancellation , limit: 255
      t.string :request_type , limit: 255
      t.string :system_id , limit: 255
      t.datetime :transaction_date 
      t.integer :transaction_number , limit: 8, null: false
      t.string :transaction_status , limit: 255
      t.string :user_id , limit: 255
      t.integer :user_name , limit: 8
      t.string :borrower_nvtgc , limit: 255
      t.string :original_nvtgc , limit: 255
      t.datetime :creation_date
      t.integer :lender_address_number
      t.timestamps null: false
    end

    create_table :illiad_user_infos do |t|
      t.belongs_to :institution, null: false
      t.string :status , limit: 255
      t.string :department , limit: 255
      t.string :nvtgc , limit: 255
      t.string :org , limit: 255
      t.string :rank , limit: 255
      t.timestamps null: false
    end

  end
end

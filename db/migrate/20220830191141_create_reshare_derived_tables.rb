class CreateReshareDerivedTables < ActiveRecord::Migration[5.2]


  def change
    create_table :reshare_transactions do |t|
      t.column :borrower, :string
      t.column :lender, :string
      t.column :request_id, :string
      t.column :borrower_id, :string
      t.column :lender_id, :string
      t.column :date_created, :datetime
      t.column :borrower_last_updated, :datetime
      t.column :lender_last_updated, :datetime
      t.column :borrower_status, :string
      t.column :lender_status, :string
      t.column :title, :string
      t.column :publication_date, :string
      t.column :place_of_publication, :string
      t.column :publisher, :string
      t.column :call_number, :string
      t.column :oclc_number, :string
      t.column :barcode, :string
      t.column :pick_location, :string
      t.column :shelving_location, :string
      t.column :pickup_location, :string

      t.index [
        :borrower_id,
        :lender_id
      ], unique: true, name: :transaction_index
    end

    create_table :reshare_lending_turnarounds do |t|
      t.column :lender, :string
      t.column :request_id, :string
      t.column :request_date, :datetime
      t.column :filled_date, :datetime
      t.column :shipped_date, :datetime
      t.column :received_date, :datetime
      t.column :time_to_fill, :numeric
      t.column :time_to_ship, :numeric
      t.column :time_to_receipt, :numeric
      t.column :total_time, :numeric

      t.index [
        :lender,
        :request_id
      ], unique: true, name: :lending_turnaround_index
    end

    create_table :reshare_borrowing_turnarounds do |t|
      t.column :borrower, :string
      t.column :request_id, :string
      t.column :request_date, :datetime
      t.column :shipped_date, :datetime
      t.column :received_date, :datetime
      t.column :time_to_ship, :numeric
      t.column :time_to_receipt, :numeric
      t.column :total_time, :numeric

      t.index [
        :borrower,
        :request_id
      ], unique: true, name: :borrowing_turnaround_index
    end

    # Remove unnecessary columns from directory entries
    remove_column :reshare_directory_entries, :custom_properties_id, :bigint
    remove_column :reshare_directory_entries, :de_foaf_timestamp, :bigint
    remove_column :reshare_directory_entries, :de_foaf_url, :string
    remove_column :reshare_directory_entries, :de_desc, :string
    remove_column :reshare_directory_entries, :de_entry_url, :string
    remove_column :reshare_directory_entries, :de_phone_number, :string
    remove_column :reshare_directory_entries, :de_email_address, :string
    remove_column :reshare_directory_entries, :de_contact_name, :string
    remove_column :reshare_directory_entries, :de_type_rv_fk, :string
    remove_column :reshare_directory_entries, :de_published_last_update, :bigint
    remove_column :reshare_directory_entries, :de_branding_url, :string

    # Remove confusing column from status table
    remove_column :reshare_status, :st_owner, :string

  end
end

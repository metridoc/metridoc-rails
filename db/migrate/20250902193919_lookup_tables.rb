class LookupTables < ActiveRecord::Migration[7.1]
  def change
    create_table :upenn_school_names do |t|
      t.string "code"
      t.string "alma_affiliations"
      t.string "ira_affiliations"
      t.boolean "is_school"

      t.index ["alma_affiliations"], unique: true
    end

    create_table :upenn_library_doors do |t|
      t.string "library_code"
      t.string "library_name"
      t.string "door_name"
      
      t.index ["door_name"], unique: true
    end

    create_table :gate_count_legacy_biotech_counts do |t|
      t.integer "fiscal_year"
      t.integer "year"
      t.integer "month"
      t.string "month_name"
      t.integer "value"

      t.index ["year","month"], unique: true
    end
  end
end

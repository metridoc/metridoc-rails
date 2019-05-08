class BdEbInstitutionsTableChange < ActiveRecord::Migration[5.1]
  def up
    unless column_exists?(:borrowdirect_institutions, :weighting_factor)
      drop_table :borrowdirect_institutions
      create_table :borrowdirect_institutions do |t|
        t.integer :library_id, null: false
        t.string  :library_symbol, limit: 25, null: false
        t.string  :institution_name, limit: 100
        t.string  :prime_post_zipcode, limit: 16
        t.decimal :weighting_factor, precision: 5, scale: 2
      end
    end
    unless column_exists?(:ezborrow_institutions, :weighting_factor)
      drop_table :ezborrow_institutions
      create_table :ezborrow_institutions do |t|
        t.integer :library_id, null: false
        t.string  :library_symbol, limit: 25, null: false
        t.string  :institution_name, limit: 100
        t.string  :prime_post_zipcode, limit: 16
        t.decimal :weighting_factor, precision: 5, scale: 2
      end
    end
  end
  def down
    if column_exists?(:borrowdirect_institutions, :weighting_factor)
      drop_table :borrowdirect_institutions
      create_table :borrowdirect_institutions do |t|
        t.string :catalog_code, limit: 1, null: false
        t.string :institution, limit: 64, null: false
        t.integer :library_id
        t.boolean :is_legacy, default: false, null: false
      end
    end
    if column_exists?(:ezborrow_institutions, :weighting_factor)
      drop_table :ezborrow_institutions
      create_table :ezborrow_institutions do |t|
        t.string  :catalog_code, limit: 1, null: false
        t.string  :institution, limit: 64, null: false
        t.integer :library_id
        t.boolean :is_legacy, default: false, null: false
      end
    end
  end
end

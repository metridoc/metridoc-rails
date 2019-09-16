class CreateLibraryProfileTables < ActiveRecord::Migration[5.1]
  def change
    create_table :library_profile_profiles do |t|
      t.string :institution_name
      t.string :library_name
      t.string :zip_code
      t.string :country
      t.string :oclc_symbol
      t.string :docline_symbol
      t.string :borrowdirect_symbol
      t.string :null_ignore
      t.string :palci
      t.string :trln
      t.string :btaa
      t.string :gwla
      t.string :blc
      t.string :aserl
      t.string :viva
    end
  end
end

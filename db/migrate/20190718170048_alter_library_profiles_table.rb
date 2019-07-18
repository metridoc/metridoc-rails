class AlterLibraryProfilesTable < ActiveRecord::Migration[5.1]
  def change
    drop_table :library_profile_profiles do; end

    create_table :library_profile_profiles do |t|
      t.string :institution_name
      t.string :library_name
      t.string :library_name_symbol
      t.string :also_called
      t.string :zip_code
      t.string :country
      t.string :oclc_symbol
      t.string :docline_symbol
      t.string :borrowdirect_symbol
      t.string :palci
      t.string :trln
      t.string :btaa
      t.string :gwla
      t.string :blc
      t.string :aserl
      t.string :viva
      t.string :bd
    end

  end
end

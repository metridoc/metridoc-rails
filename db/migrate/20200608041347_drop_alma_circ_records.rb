class DropAlmaCircRecords < ActiveRecord::Migration[5.2]
  def up
    drop_table :alma_circ_records if ActiveRecord::Base.connection.table_exists? 'alma_circ_records'
  end
  def down
    
  end
end

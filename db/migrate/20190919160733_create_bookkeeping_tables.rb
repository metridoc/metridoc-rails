class CreateBookkeepingTables < ActiveRecord::Migration[5.1]
  def change
    create_table :bookkeeping_data_loads do |t|
      t.string :table_name
      t.string :earliest
      t.string :latest
    end
  end
end

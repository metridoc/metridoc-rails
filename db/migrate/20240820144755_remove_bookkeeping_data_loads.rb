class RemoveBookkeepingDataLoads < ActiveRecord::Migration[7.1]
  def change
    drop_table :bookkeeping_data_loads, if_exists: true
  end
end

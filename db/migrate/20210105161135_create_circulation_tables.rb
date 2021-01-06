class CreateCirculationTables < ActiveRecord::Migration[5.2]
  def change
    create_table :circulation_pick_up_requests do |t|
      t.string :location
      t.integer :received
      t.integer :local_processed
      t.integer :offsite_processed
      t.integer :abandoned
      t.datetime :date
    end
  end
end

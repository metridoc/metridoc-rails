class DropReshareStatFillsTable < ActiveRecord::Migration[5.2]
  def change
    drop_table :reshare_stat_fills
  end
end

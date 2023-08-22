class AddItemCreationToAlmaCirculation < ActiveRecord::Migration[5.2]
  def change
    add_column :alma_circulations, :item_creation, :date
  end
end

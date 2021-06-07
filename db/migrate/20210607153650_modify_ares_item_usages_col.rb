class ModifyAresItemUsagesCol < ActiveRecord::Migration[5.2]
  def up
    change_column :ares_item_usages, :digital_item, :boolean, using: 'digital_item::boolean'
  end
  def down
    change_column :ares_item_usages, :digital_item, :integer, using: 'digital_item::integer'
  end
end

class RemoveUsernameFromTransactions < ActiveRecord::Migration[5.1]
  def up
    remove_column :illiad_transactions, :user_name if column_exists?(:illiad_transactions, :user_name)
  end
  def down
    add_column :illiad_transactions, :user_name, :string unless column_exists?(:illiad_transactions, :user_name)
  end
end

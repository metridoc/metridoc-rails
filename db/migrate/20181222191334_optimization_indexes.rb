class OptimizationIndexes < ActiveRecord::Migration[5.1]
  def up
    add_index :illiad_borrowings, [:transaction_status] unless index_exists?(:illiad_borrowings, :transaction_status)
    add_index :illiad_borrowings, [:transaction_number] unless index_exists?(:illiad_borrowings, :transaction_number)
    add_index :illiad_trackings, [:order_date] unless index_exists?(:illiad_trackings, :order_date)
  end
  def down
    remove_index :illiad_borrowings, [:transaction_status] if index_exists?(:illiad_borrowings, :transaction_status)
    remove_index :illiad_borrowings, [:transaction_number] if index_exists?(:illiad_borrowings, :transaction_number)
    remove_index :illiad_trackings, [:order_date] if index_exists?(:illiad_trackings, :order_date)
  end
end

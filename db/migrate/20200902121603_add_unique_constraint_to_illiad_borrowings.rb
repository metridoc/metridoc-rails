class AddUniqueConstraintToIlliadBorrowings < ActiveRecord::Migration[5.2]
  def change
   add_index :illiad_borrowing, [:institution_id, :transaction_number, :request_type, :transaction_status, :transaction_date], unique: true
  end
end
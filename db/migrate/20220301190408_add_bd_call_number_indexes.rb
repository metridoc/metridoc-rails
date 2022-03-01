class AddBdCallNumberIndexes < ActiveRecord::Migration[5.2]
  def change
    add_index :borrowdirect_bibliographies, :call_number, using: 'hash'
    add_index :borrowdirect_bibliographies, :supplier_code
  end
end

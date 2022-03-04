class AddEzborrowCallNumbersIndexes < ActiveRecord::Migration[5.2]
  def change
    add_index :ezborrow_call_numbers, :call_number, using: 'hash'
    add_index :ezborrow_call_numbers, :request_number
    add_index :ezborrow_call_numbers, :supplier_code
    add_index :borrowdirect_call_numbers, :call_number, using: 'hash'
    add_index :borrowdirect_call_numbers, :supplier_code
  end
end

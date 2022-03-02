class AddPennkeyIndex < ActiveRecord::Migration[5.2]
  def change
    change_column_null :upenn_alma_demographics, :penn_id, false
    change_column_null :upenn_alma_demographics, :pennkey, false
    add_index :upenn_alma_demographics, [:pennkey, :penn_id], unique: true
  end
end

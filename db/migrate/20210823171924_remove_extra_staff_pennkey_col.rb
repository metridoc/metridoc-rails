class RemoveExtraStaffPennkeyCol < ActiveRecord::Migration[5.2]
  def up
    remove_column :misc_consultation_data, :staff_penn_key
  end

  def down
    add_column :misc_consultation_data, :staff_penn_key, :string
  end
end

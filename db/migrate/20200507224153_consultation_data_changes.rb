class ConsultationDataChanges < ActiveRecord::Migration[5.2]
  def change
    add_column :misc_consultation_data, :staff_penn_key, :string
  end
end

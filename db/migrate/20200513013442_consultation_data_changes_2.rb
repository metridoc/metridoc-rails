class ConsultationDataChanges2 < ActiveRecord::Migration[5.2]
  def change
    add_column :misc_consultation_data, :rtg, :string
    add_column :misc_consultation_data, :mba_type, :string
    add_column :misc_consultation_data, :campus, :string
    add_column :misc_consultation_data, :patron_name, :string
    add_column :misc_consultation_data, :graduation_year, :integer
  end
end

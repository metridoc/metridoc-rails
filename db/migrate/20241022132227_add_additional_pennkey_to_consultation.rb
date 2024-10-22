class AddAdditionalPennkeyToConsultation < ActiveRecord::Migration[7.1]
  def change
    add_column :consultation_interactions, :additional_staff_pennkey, :string
  end
end

class AddConsultationInstructionIndexes < ActiveRecord::Migration[5.2]
  def change
    add_index :consultation_interactions, :outcome
    add_index :consultation_interactions, :patron_question
    add_index :consultation_interactions, :staff_pennkey
  end
end

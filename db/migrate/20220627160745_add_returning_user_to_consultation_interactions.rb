class AddReturningUserToConsultationInteractions < ActiveRecord::Migration[5.2]
  def change
    add_column :consultation_interactions, :returning_user, :boolean
  end
end

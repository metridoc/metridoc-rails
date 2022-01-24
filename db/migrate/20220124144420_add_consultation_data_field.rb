class AddConsultationDataField < ActiveRecord::Migration[5.2]
  def change
    add_column :consultation_interactions, :upload_record, :boolean, :default => true
  end
end

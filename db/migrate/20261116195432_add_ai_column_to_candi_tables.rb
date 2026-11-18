class AddAiColumnToCandiTables < ActiveRecord::Migration[8.1]
  def change

    add_column :ss_libwizard_candi_autos, :ai_related, :string
    add_column :ss_libwizard_candi_manuals, :ai_related, :string

    add_column :ss_libwizard_candi_autos, :internal_consult, :string
    add_column :ss_libwizard_candi_manuals, :internal_consult, :string
  
  end
end

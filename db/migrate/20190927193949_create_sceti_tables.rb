class CreateScetiTables < ActiveRecord::Migration[5.1]
    def change
        
	create_table :sceti_projects do |t|
            t.string :name, null: false
            t.boolean :active
        end
      
	create_table :sceti_trackings do |t|
	    t.references :sceti_project, foreign_key: true
            t.date :date_received_in_sceti
            t.date :date_returned
            t.date :deadline
            t.boolean :remove_from_project
            t.string :mms_id
            t.string :ark_id
            t.integer :image_count
            t.string :pages_to_digitize
            t.string :file_location
            t.string :title
            t.string :patron_name
            t.text :condition_notes
            t.text :general_notes
            t.boolean :qa
            t.string :imaged_by
            t.date :imaged_date
            t.string :uploaded_to_colenda_by
            t.date :uploaded_to_colenda_date
            t.string :qa_by
            t.date :qa_date
            t.string :metadata_created_by
            t.date :metadata_created_date
            t.string :web_qa_by
            t.date :web_qa_date
        end
      
        
    end
  end
  

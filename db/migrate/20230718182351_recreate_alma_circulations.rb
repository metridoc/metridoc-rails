class RecreateAlmaCirculations < ActiveRecord::Migration[5.2]
  def change
    drop_table :alma_circulations do |t|
      t.string :policy_name
      t.string :barcode
      t.string :item_id
      t.string :permanent_call_number
      t.string :classification_code
      t.string :lc_group1
      t.string :lc_group2
      t.string :lc_group3
      t.string :lc_group4
      t.string :lc_group5
      t.string :dewey_number
      t.string :dewey_group1
      t.string :dewey_group2
      t.string :dewey_group3
      t.string :mms_id
      t.string :title
      t.string :title_normalized
      t.string :author
      t.string :bibliographic_material_type
      t.string :physical_item_material_type
      t.string :bibliographic_resource_type
      t.string :isbn
      t.string :isbn_normalized
      t.string :issn
      t.string :issn_normalized
      t.string :oclc_control_number_019
      t.string :oclc_control_number_035a
      t.string :oclc_control_number_035z
      t.string :oclc_control_number_035az
      t.string :library_name
      t.string :location_name
      t.string :resource_sharing_library
      t.string :user_group
      t.string :statistical_category_1
      t.string :statistical_category_2
      t.string :statistical_category_3
      t.string :statistical_category_4
      t.string :statistical_category_5
      t.string :loan_year
      t.string :loan_fiscal_year
      t.datetime :loan_date
      t.datetime :due_date
      t.datetime :original_due_date
    end

    create_table :alma_circulations do |t|
      t.numeric :item_loan_id
      t.date :last_status_update
      t.string :process_status
      t.string :loan_status
      t.string :physical_item_material_type
      t.string :bibliographic_material_type
      t.string :bibliographic_resource_type
      t.numeric :loan_fiscal_year
      t.numeric :loan_year
      t.date :loan_date
      t.numeric :renewals
      t.date :due_date
      t.date :original_due_date
      t.date :return_date
      t.string :policy_name
      t.string :library_name
      t.string :location_name
      t.string :title
      t.string :title_normalized
      t.string :author
      t.string :physical_item_id
      t.string :barcode
      t.string :mms_id
      t.string :isbn
      t.string :isbn_normalized
      t.string :issn
      t.string :issn_normalized
      t.string :oclc_control_number_019
      t.string :oclc_control_number_035a
      t.string :oclc_control_number_035z
      t.string :oclc_control_number_035az
      t.string :permanent_call_number
      t.string :classification_code
      t.string :lc_group1
      t.string :lc_group2
      t.string :lc_group3
      t.string :lc_group4
      t.string :lc_group5
      t.string :dewey_number
      t.string :dewey_group1
      t.string :dewey_group2
      t.string :dewey_group3
      t.string :first_name
      t.string :last_name
      t.string :preferred_email
      t.string :penn_id_number
      t.string :user_id
      t.string :user_group
      t.string :school
      t.string :statistical_category_1
      t.string :statistical_category_2
      t.string :statistical_category_3
      t.string :statistical_category_4
      t.string :statistical_category_5

      # Unique column identifier
      t.index ["item_loan_id"], name: "alma_circulations_item_loan_id", unique: true
      t.index ["last_status_update"], name: "alma_circulations_last_status_update"

      # User information for aggregation
      t.index ["user_group"], name: "alma_circulations_user_group"
      t.index ["school"], name: "alma_circulations_school"

      # Source information
      t.index ["library_name"], name: "alma_circulations_library_name"
      t.index ["location_name"], name: "alma_circulations_location_name"

      # Status information
      t.index ["process_status"], name: "alma_circulations_process_status"
      t.index ["loan_status"], name: "alma_circulations_loan_status"

      # Item information
      t.index ["physical_item_material_type"], name: "alma_circulations_physical_item_material_type"
      t.index ["bibliographic_material_type"], name: "alma_circulations_bibliographic_material_type"
      t.index ["bibliographic_resource_type"], name: "alma_circulations_bibliographic_resource_type"
    end
  end
end

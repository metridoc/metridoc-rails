class CreateAlmaTable < ActiveRecord::Migration[5.2]
  def change
    create_table :alma_circ_records do |t|
      t.string   :policy_name
      t.string   :barcode
      t.string   :item_id
      t.string   :permanent_call_number
      t.string   :classification_code
      t.string   :lc_group1
      t.string   :lc_group2
      t.string   :lc_group3
      t.string   :lc_group4
      t.string   :lc_group5
      t.string   :dewey_number
      t.string   :dewey_group1
      t.string   :dewey_group2
      t.string   :dewey_group3
      t.string   :mms_id
      t.string   :title
      t.string   :title_normalized
      t.string   :author
      t.string   :bibliographic_material_type
      t.string   :physical_item_material_type
      t.string   :bibliographic_resource_type
      t.string   :isbn
      t.string   :isbn_normalized
      t.string   :issn
      t.string   :issn_normalized
      t.string   :oclc_control_number_019
      t.string   :oclc_control_number_035a
      t.string   :oclc_control_number_035z
      t.string   :oclc_control_number_035a_z
      t.string   :library_name
      t.string   :location_name
      t.string   :resource_sharing_library
      t.string   :user_group
      t.string   :statistical_category_1
      t.string   :statistical_category_2
      t.string   :statistical_category_3
      t.string   :statistical_category_4
      t.string   :statistical_category_5
      t.integer  :loan_year
      t.string   :loan_fiscal_year
      t.date     :loan_date
      t.date     :due_date
      t.string   :original_due_date
      t.timestamps null: false
    end
  end
end

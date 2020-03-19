ActiveAdmin.register Alma::Circulation do
  menu false
  permit_params :policy_name, :barcode, :item_id, :permanent_call_number, :classification_code, :lc_group1, :lc_group2, :lc_group3, :lc_group4, :lc_group5, :mms_id, :title, :title_normalized, :author, :bibliographic_material_type, :physical_item_material_type, :bibliographic_resource_type, :isbn, :isbn_normalized, :issn, :issn_normalized, :oclc_control_number_019, :oclc_control_number_035a, :oclc_control_number_035z, :oclc_control_number_az, :library_name, :location_name, :resource_sharing_library, :user_group, :statistical_category_1, :statistical_category_2, :statistical_category_3, :statistical_category_4, :statistical_category_5, :loan_year, :loan_fiscal_year, :loan_date, :due_date, :original_due_date
end
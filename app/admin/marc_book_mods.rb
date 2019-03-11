ActiveAdmin.register Marc::BookMod do
  menu false

  permit_params   :title, 
                  :name, 
                  :name_date, 
                  :role, 
                  :type_of_resource, 
                  :genre, 
                  :origin_place_code, 
                  :origin_place, 
                  :origin_publisher, 
                  :origin_date_issued, 
                  :origin_issuance, 
                  :language, 
                  :physical_description_form, 
                  :physical_description_extent, 
                  :notes, 
                  :subject, 
                  :classification, 
                  :related_item_title, 
                  :lccn_identifier, 
                  :oclc_identifier, 
                  :record_content_source, 
                  :record_creation_date, 
                  :record_change_date, 
                  :record_identifier, 
                  :record_origin

  actions :all, :except => [:edit, :update, :destroy]
end
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

  actions :all, :except => [:new, :edit, :update, :destroy]

  preserve_default_filters!

  filter :title, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :name, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :name_date, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :role, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :type_of_resource, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :genre, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :origin_place_code, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :origin_place, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :origin_publisher, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :origin_date_issued, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :origin_issuance, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :language, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :physical_description_form, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :physical_description_extent, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :notes, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :subject, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :classification, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :related_item_title, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :lccn_identifier, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :oclc_identifier, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :record_content_source, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :record_creation_date, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :record_change_date, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :record_identifier, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :record_origin, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]

end
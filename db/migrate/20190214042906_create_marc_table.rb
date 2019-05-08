class CreateMarcTable < ActiveRecord::Migration[5.1]
  def change
    create_table :marc_book_mods do |t|
      t.string :title
      t.string :name
      t.string :name_date
      t.string :role
      t.string :type_of_resource
      t.string :genre
      t.string :origin_place_code
      t.string :origin_place
      t.string :origin_publisher
      t.string :origin_date_issued
      t.string :origin_issuance
      t.string :language
      t.string :physical_description_form
      t.string :physical_description_extent
      t.string :subject
      t.string :classification
      t.string :related_item_title
      t.string :lccn_identifier
      t.string :oclc_identifier
      t.string :record_content_source
      t.string :record_creation_date
      t.string :record_change_date
      t.string :record_identifier
      t.string :record_origin
    end
  end
end

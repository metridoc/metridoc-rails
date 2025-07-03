class LegantoTableAdjustments < ActiveRecord::Migration[7.1]
  def change

    # Build new reading lists table
    create_table :cr_leganto_reading_lists do |t|
      t.bigint :reading_list_id
      t.datetime :creation_date
      t.integer :number_of_citations
      t.string :status
      t.string :has_course_association
      t.date :visible_start_date
      t.date :visible_end_date
      t.string :owner
      t.string :owner_pennid
      t.datetime :modification_date

      t.index ["reading_list_id"], unique: true
    end

    # Courses table adjustments
    add_column :cr_leganto_courses, :creation_date, :datetime
    add_column :cr_leganto_courses, :modification_date, :datetime
    remove_column :cr_leganto_courses, :last_updated_at, :datetime
    remove_column :cr_leganto_courses, :course_modification_date, :date

    # Course citation mapping table adjustments.
    add_column :cr_leganto_course_citations, :reading_list_id, :bigint
    add_column :cr_leganto_course_citations, :modification_date, :datetime
    add_index :cr_leganto_course_citations, [:course_id, :reading_list_id, :citation_id], unique: true, name: "cr_leganto_course_citations_usage_id"

    # Citation table adjustments
    # Date to datetime corrections
    remove_column :cr_leganto_citations, :citation_creation_date, :date
    add_column :cr_leganto_citations, :creation_date, :datetime

    remove_column :cr_leganto_citations, :citation_modification_date, :date
    add_column :cr_leganto_citations, :modification_date, :datetime

    # Columns missing
    add_column :cr_leganto_citations, :citation_order, :integer

    # Columns not needed
    remove_column :cr_leganto_citations, :citation_material_type, :string
    remove_column :cr_leganto_citations, :active_course_code, :string
    remove_column :cr_leganto_citations, :electronic_location_and_access, :string
    remove_column :cr_leganto_citations, :category_of_material, :string
    remove_column :cr_leganto_citations, :form_of_item, :string
    remove_column :cr_leganto_citations, :is_alma_digital_citation, :string
    remove_column :cr_leganto_citations, :is_repository_citation, :string

    # Renaming columns
    rename_column :cr_leganto_citations, :citation_created_by, :created_by
    rename_column :cr_leganto_citations, :citation_copyright_status, :copyrights_status
    rename_column :cr_leganto_citations, :pub_year, :publication_year

    # Columns to be calculated after upload
    add_column :cr_leganto_citations, :has_physical, :boolean
    add_column :cr_leganto_citations, :has_electronic, :boolean


    # Usage table adjustments
    add_column :cr_leganto_usage, :reading_list_id, :bigint
    add_column :cr_leganto_usage, :user_role, :string
    add_column :cr_leganto_usage, :student_type, :string

    add_column :cr_leganto_usage, :citation_views, :integer
    add_column :cr_leganto_usage, :files_downloaded, :integer
    add_column :cr_leganto_usage, :file_views, :integer
    add_column :cr_leganto_usage, :full_text_views, :integer

    remove_column :cr_leganto_usage, :citation_origin, :string
    remove_column :cr_leganto_usage, :usage_type, :string

    # Remove unique constraint on the Courses table
    remove_index :cr_leganto_courses, column: :course_code, unique: true
    add_index :cr_leganto_courses, :course_code

  end
end

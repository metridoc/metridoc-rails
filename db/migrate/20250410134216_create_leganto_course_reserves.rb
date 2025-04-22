class CreateLegantoCourseReserves < ActiveRecord::Migration[7.1]
  def change
    create_table :cr_leganto_courses do |t|
      t.integer :course_id
      t.string :course_code
      t.string :course_term
      t.string :course_year
      t.string :academic_department
      t.datetime :course_start_date
      t.datetime :course_end_date
      t.integer :course_enrollment
      t.string :course_name
      t.string :processing_department
      t.datetime :last_updated_at

      t.index ["course_id"], name: "cr_leganto_courses_course_id"
      t.index ["course_year"], name: "cr_leganto_courses_course_year"
    end

    create_table :cr_leganto_items do |t|
      t.integer :citation_id
      t.string :citation_title
      t.string :citation_author
      t.string :citation_publisher
      t.string :citation_pub_year
      t.string :citation_isbn
      t.string :citation_issn
      t.string :citation_journal_title
      t.string :citation_journal_issue
      t.string :citation_material_type
      t.datetime :citation_creation_date
      t.string :citation_origin
      t.string :citation_type
      t.string :citation_copyright_status
      t.boolean :is_repository_citation
      t.string :citation_created_by
      t.string :citation_uploaded_file
      t.string :external_source_id
      t.datetime :last_updated_at
      t.index ["citation_id"], name: "cr_leganto_items_citation_id"
    end

    create_table :cr_leganto_usage do |t|
      t.string :usage_type
      t.string :format
      t.datetime :time_of_use
      t.datetime :last_updated_at
    end

  end
end

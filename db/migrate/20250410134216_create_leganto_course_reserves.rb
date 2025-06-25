class CreateLegantoCourseReserves < ActiveRecord::Migration[7.1]
  def change
    create_table :cr_leganto_courses do |t|
      t.bigint :course_id
      t.date :course_modification_date
      t.string :course_code
      t.string :course_name
      t.string :academic_department
      t.string :course_term
      t.string :course_year
      t.datetime :course_start_date
      t.datetime :course_end_date
      t.integer :course_enrollment
      t.string :processing_department
      t.datetime :last_updated_at

      t.index ["course_id"], unique: true, name: "cr_leganto_courses_course_id"
      t.index ["course_code"], unique: true, name: "cr_leganto_courses_course_code"
    end

    create_table :cr_leganto_citations do |t|
      t.bigint :citation_id
      t.date :citation_creation_date
      t.string :citation_created_by
      t.string :citation_copyright_status
      t.string :citation_material_type
      t.string :citation_origin
      t.string :citation_source
      t.string :citation_type
      t.string :citation_uploaded_file
      t.string :external_source_id
      t.string :is_alma_digital_citation
      t.string :is_repository_citation
      t.date :citation_modification_date
      t.string :title
      t.string :author
      t.string :publisher
      t.string :pub_year
      t.string :journal_title
      t.string :isbn
      t.string :issn
      t.string :book_chapter_title
      t.string :issue
      t.string :volume
      t.string :active_course_code
      t.string :category_of_material
      t.string :electronic_location_and_access
      t.string :form_of_item
      t.string :material_type
      t.string :resource_type
      t.index ["citation_id"], unique: true, name: "cr_leganto_items_citation_id"
    end

    create_table :cr_leganto_usage do |t|
      t.bigint :course_id
      t.bigint :citation_id
      t.date :event_date
      t.string :citation_origin
      t.string :link_type
      t.string :usage_type
    end

    create_table :cr_leganto_course_citations do |t|
      t.bigint :course_id
      t.bigint :citation_id
      t.index ["course_id"], name: "cr_leganto_course_citations_course_id"
      t.index ["citation_id"], name: "cr_leganto_course_citations_citation_id"
    end

  end
end

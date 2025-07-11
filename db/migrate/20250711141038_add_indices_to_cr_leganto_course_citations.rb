class AddIndicesToCrLegantoCourseCitations < ActiveRecord::Migration[7.1]
  def change
    add_index :cr_leganto_usage, [
      :course_id, :citation_id, :reading_list_id, :event_date,
      :user_role, :student_type, :link_type
      ], unique: true, name: 'cr_leganto_usage_index'
    add_index :cr_leganto_usage, :course_id
    add_index :cr_leganto_usage, :reading_list_id
    add_index :cr_leganto_usage, :citation_id
    add_index :cr_leganto_usage, :event_date

    add_column :cr_leganto_usage, :total_views, :integer
  end
end

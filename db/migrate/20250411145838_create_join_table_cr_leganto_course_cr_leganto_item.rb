class CreateJoinTableCrLegantoCourseCrLegantoItem < ActiveRecord::Migration[7.1]
  def change
    create_join_table :cr_leganto_courses, :cr_leganto_items do |t|
      t.index [:cr_leganto_course_id, :cr_leganto_item_id]
      t.index [:cr_leganto_item_id, :cr_leganto_course_id]
    end
  end
end

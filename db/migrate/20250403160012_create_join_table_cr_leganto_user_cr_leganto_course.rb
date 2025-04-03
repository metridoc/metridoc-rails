class CreateJoinTableCrLegantoUserCrLegantoCourse < ActiveRecord::Migration[7.1]
  def change
    create_join_table :cr_leganto_users, :cr_leganto_courses do |t|
      # t.index [:cr_leganto_user_id, :cr_leganto_course_id]
      # t.index [:cr_leganto_course_id, :cr_leganto_user_id]
    end
    create_join_table :cr_leganto_courses, :cr_leganto_items do |t|
      # t.index [:cr_leganto_course_id, :cr_leganto_item_id]
      # t.index [:cr_leganto_item_id, :cr_leganto_course_id]
    end
  end
end

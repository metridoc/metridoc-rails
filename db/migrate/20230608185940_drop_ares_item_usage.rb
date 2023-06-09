class DropAresItemUsage < ActiveRecord::Migration[5.2]
  def up
    drop_table :ares_item_usages do |t|
      t.string   :semester
      t.string   :item_id
      t.datetime :date_time
      t.string   :document_type
      t.string   :item_format
      t.string   :course_id
      t.integer  :digital_item
      t.string   :course_number
      t.string   :department
      t.integer  :date_time_year
      t.integer  :date_time_month
      t.integer  :date_time_day
      t.integer  :date_time_hour
    end
  end
end

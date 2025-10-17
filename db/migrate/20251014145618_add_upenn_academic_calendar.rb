class AddUpennAcademicCalendar < ActiveRecord::Migration[7.1]
  def change
    create_table :upenn_academic_calendars do |t|
      t.integer "calendar_year"
      t.integer "fiscal_year"
      t.string "term"
      t.date "start_date"
      t.date "end_date"

      t.index ["fiscal_year", "term"], unique: true, name: "upenn_academic_calendar_term_id"
    end
  end
end

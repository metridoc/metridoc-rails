class AddEzpaarseReports < ActiveRecord::Migration[7.1]
  def change

    create_table :ezpaarse_job_reports do |t|
      t.date "date"
      t.string "filename"
      t.float "lines_input"
      t.float "ecs"
      t.float "denied_ecs"
      t.float "ignored"
      t.float "duplicate_ecs"
      t.float "ignored_domains"
      t.float "unknown_domains"
      t.float "unknown_formats"
      t.float "unqualified_ecs"
      t.float "unordered_ecs"
      t.float "ignored_hosts"
      t.float "robots_ecs"
      t.float "unknown_errors"
      t.float "on_campus"
      t.float "off_campus"

      t.index ["filename"], name: "ezpaarse_job_report_date", unique: true
    end
  end
end

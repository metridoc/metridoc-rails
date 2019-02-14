class LoggingTables < ActiveRecord::Migration[5.1]
  def change

    create_table :log_job_executions do |t|
      t.string   :source_name, null: false
      t.string   :job_type, null: false
      t.string   :mac_address
      t.json     :global_yml, null: false
      t.datetime :started_at, null: false
      t.datetime :status_set_at, null: false
      t.string   :status, null: false
      t.text     :log_text
    end

    create_table :log_job_execution_steps do |t|
      t.belongs_to :job_execution, null: false
      t.string     :step_name, null: false
      t.json       :step_yml, null: false
      t.datetime   :started_at, null: false
      t.datetime   :status_set_at, null: false
      t.string     :status, null: false
      t.text       :log_text
    end

  end
end

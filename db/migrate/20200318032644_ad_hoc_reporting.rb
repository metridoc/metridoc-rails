class AdHocReporting < ActiveRecord::Migration[5.2]
  def change

    create_table :report_templates do |t|
      t.string   :name, null: false
      t.string   :comments

      t.string   :select_section
      t.string   :from_section
      t.string   :where_section
      t.string   :group_by_section
      t.string   :order_section

      t.timestamps null: false
    end

    create_table :report_queries do |t|
      t.belongs_to  :report_template
      t.integer     :owner_id, null: false
      t.string      :name, null: false
      t.string      :comments

      t.string      :select_section
      t.string      :from_section
      t.string      :where_section
      t.string      :group_by_section
      t.string      :order_section

      t.string      :status
      t.datetime    :last_run_at
      t.string      :last_error_message
      t.string      :output_file_name

      t.timestamps null: false
    end

  end
end

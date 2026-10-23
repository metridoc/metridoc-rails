class Keyserver < ActiveRecord::Migration[8.1]
  def change
    drop_table :keyserver_computers do |t|
      t.string :computer_name
      t.datetime :created_at
      t.string :location
      t.string :section
      t.datetime :updated_at
    end
    
    create_table :keyserver_computers do |t|
      t.string :ident, null: false
      t.string :computer_name, null: false
      t.string :section
      t.string :division
      t.string :os_family
      t.string :domain

      t.index :ident, unique: true
    end

    create_table :keyserver_products do |t|
      t.string :ident, null: false
      t.string :product_name
      t.integer :install_count
      t.string :category

      t.index :ident, unique: true
    end

    create_table :keyserver_reports do |t|
      t.string :ident, null: false
      t.string :name
      t.integer :module_id
      t.string :module_name
      t.string :author
      t.datetime :created
      t.datetime :start
      t.string :range
      t.integer :size
      t.numeric :runtime
      t.datetime :downloaded

      t.index :ident, unique: true
    end

    drop_view :keyserver_software_usage_profiles, revert_to_version: 1
    drop_view :keyserver_non_staff_computers, revert_to_version: 1
    drop_view :keyserver_software_usage_by_schools, revert_to_version: 1
    drop_view :keyserver_software_usage_by_user_groups, revert_to_version: 1
    drop_view :keyserver_location_by_hours, revert_to_version: 2
    drop_view :keyserver_location_by_dows, revert_to_version: 2

    drop_table :keyserver_sessions do |t|
      t.string "address"
      t.string "computer_name"
      t.datetime "created_at"
      t.bigint "duration"
      t.string "location"
      t.datetime "logoff"
      t.datetime "logon"
      t.datetime "updated_at"
      t.string "user_name"
      t.index ["computer_name", "logon", "logoff"], name: "index_keyserver_sessions_on_computer_name_and_logon_and_logoff"
      t.index ["computer_name", "user_name", "logon"], name: "index_keyserver_sessions_natural_key", unique: true
      t.index ["location", "logon"], name: "index_keyserver_sessions_on_location_and_logon"
      t.index ["user_name"], name: "index_keyserver_sessions_on_user_name"
    end

    create_table :keyserver_sessions do |t|
      t.string :computer_name
      t.string :division
      t.datetime :start_time
      t.datetime :end_time
      t.interval :duration
      t.string :user_name
      t.string :user_group
      t.string :school

      t.index [:computer_name, :start_time, :user_name], unique: true

      t.index 'LOWER(user_name)', 
        name: 'index_keyserver_session_on_lower_user_name', 
        if_not_exists: true
    end

    create_table :keyserver_product_usage do |t|
      t.integer :ident
      t.string :program_name
      t.string :product_name
      t.string :computer_name
      t.string :division
      t.datetime :start_time
      t.integer :duration
      t.integer :foreground
      t.integer :install_count
      t.string :user_name
      t.string :user_group
      t.string :school

      t.index [:ident, :start_time], unique: true

      t.index 'LOWER(user_name)', 
        name: 'index_keyserver_product_usage_on_lower_user_name', 
        if_not_exists: true
    end

    create_table :keyserver_program_usage do |t|
      t.integer :ident
      t.string :program_name
      t.string :product_name
      t.string :computer_name
      t.string :division
      t.datetime :start_time
      t.integer :duration
      t.integer :foreground
      t.string :user_name
      t.string :user_group
      t.string :school

      t.index [:ident, :start_time], unique: true

      t.index 'LOWER(user_name)', 
        name: 'index_keyserver_program_usage_on_lower_user_name', 
        if_not_exists: true
    end

    add_index :upenn_alma_demographics,
      "LOWER(first_name || ' ' || last_name)",
      name: 'index_upenn_alma_demographics_on_full_name',
      if_not_exists: true


    # Drop remaining deprecated tables
    drop_table :keyserver_app_name_overrides do |t|
      t.string "canonical"
      t.string "raw_name"
    end

    drop_table :keyserver_divisions do |t|
      t.string "division_flags"
      t.string "division_id"
      t.string "division_name"
      t.string "division_notes"
      t.string "division_section_id"
      t.string "division_server_id"
    end

    drop_table :keyserver_events do |t|
      t.string "address"
      t.string "application"
      t.string "computer_name"
      t.datetime "created_at"
      t.string "event_type"
      t.string "location"
      t.datetime "occurred_at"
      t.string "product"
      t.datetime "updated_at"
      t.string "user_name"
      t.string "version"
    end
  end
end

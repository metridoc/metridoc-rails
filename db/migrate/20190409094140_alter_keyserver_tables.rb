class AlterKeyserverTables < ActiveRecord::Migration[5.1]
  def change
    drop_table :keyserver_product_folders
    drop_table :keyserver_licensed_computers
    drop_table :keyserver_products
    drop_table :keyserver_purchase_orders
    drop_table :keyserver_contracts
    drop_table :keyserver_hotfixes
    drop_table :keyserver_purchase_allocations
    drop_table :keyserver_users
    drop_table :keyserver_computer_group_members
    drop_table :keyserver_policy_folders
    drop_table :keyserver_user_folders
    drop_table :keyserver_purchase_items
    drop_table :keyserver_locations
    drop_table :keyserver_program_folders
    drop_table :keyserver_licensed_users
    drop_table :keyserver_purchase_supports
    drop_table :keyserver_computer_divisions
    drop_table :keyserver_purchase_codes
    drop_table :keyserver_purchase_documents
    drop_table :keyserver_computer_groups
    drop_table :keyserver_purchase_folders
    drop_table :keyserver_audits
    drop_table :keyserver_policy_products
    drop_table :keyserver_product_components
    drop_table :keyserver_servers
    drop_table :keyserver_policies
    remove_column :keyserver_computers, :computer_server_id
    remove_column :keyserver_computers, :computer_server_id
    remove_column :keyserver_computers, :computer_user_name
    remove_column :keyserver_computers, :computer_address
    remove_column :keyserver_computers, :computer_virtual_host
    remove_column :keyserver_computers, :computer_gmt_offset
    remove_column :keyserver_computers, :computer_os_family
    remove_column :keyserver_computers, :computer_os_type
    remove_column :keyserver_computers, :computer_os_version
    remove_column :keyserver_computers, :computer_os_release
    remove_column :keyserver_computers, :computer_os_install_date
    remove_column :keyserver_computers, :computer_os64_bit
    remove_column :keyserver_computers, :computer_cpu_type
    remove_column :keyserver_computers, :computer_cpu_count
    remove_column :keyserver_computers, :computer_cpu_clock
    remove_column :keyserver_computers, :computer_cpu64_bit
    remove_column :keyserver_computers, :computer_hyper_threading
    remove_column :keyserver_computers, :computer_multicore
    remove_column :keyserver_computers, :computer_capabilities
    remove_column :keyserver_computers, :computer_ram_size
    remove_column :keyserver_computers, :computer_ram_type
    remove_column :keyserver_computers, :computer_ram_array
    remove_column :keyserver_computers, :computer_disk_size
    remove_column :keyserver_computers, :computer_free_space
    remove_column :keyserver_computers, :computer_disk_manufacturer
    remove_column :keyserver_computers, :computer_disk_model
    remove_column :keyserver_computers, :computer_display_width
    remove_column :keyserver_computers, :computer_display_height
    remove_column :keyserver_computers, :computer_display_depth
    remove_column :keyserver_computers, :computer_display_manufacturer
    remove_column :keyserver_computers, :computer_display_model
    remove_column :keyserver_computers, :computer_display_serial
    remove_column :keyserver_computers, :computer_video_manufacturer
    remove_column :keyserver_computers, :computer_video_model
    remove_column :keyserver_computers, :computer_vram_size
    remove_column :keyserver_computers, :computer_mac_address
    remove_column :keyserver_computers, :computer_mac_manufacturer
    remove_column :keyserver_computers, :computer_mac_model
    remove_column :keyserver_computers, :computer_wireless_address
    remove_column :keyserver_computers, :computer_wireless_manufacturer
    remove_column :keyserver_computers, :computer_wireless_model
    remove_column :keyserver_computers, :computer_mac_array
    remove_column :keyserver_computers, :computer_site
    remove_column :keyserver_computers, :computer_oem_serial
    remove_column :keyserver_computers, :computer_os_serial
    remove_column :keyserver_computers, :computer_baseboard_serial
    remove_column :keyserver_computers, :computer_system_serial
    remove_column :keyserver_computers, :computer_manufacturer
    remove_column :keyserver_computers, :computer_model
    remove_column :keyserver_computers, :computer_bios_serial
    remove_column :keyserver_computers, :computer_bios_model
    remove_column :keyserver_computers, :computer_bios_version
    remove_column :keyserver_computers, :computer_cdrom_present
    remove_column :keyserver_computers, :computer_cdrom_writable
    remove_column :keyserver_computers, :computer_cdrom_manufacturer
    remove_column :keyserver_computers, :computer_cdrom_model
    remove_column :keyserver_computers, :computer_dvd_present
    remove_column :keyserver_computers, :computer_dvd_writable
    remove_column :keyserver_computers, :computer_sound_manufacturer
    remove_column :keyserver_computers, :computer_sound_model
    remove_column :keyserver_computers, :computer_lease_expiration
    remove_column :keyserver_computers, :computer_last_login
    remove_column :keyserver_computers, :computer_last_audit
    remove_column :keyserver_computers, :computer_base_audit
    remove_column :keyserver_computers, :computer_client_version
    remove_column :keyserver_computers, :computer_user_session
    remove_column :keyserver_computers, :computer_acknowledged
    remove_column :keyserver_computers, :computer_allowed
    remove_column :keyserver_computers, :computer_audit
    remove_column :keyserver_computers, :computer_division_id
    remove_column :keyserver_computers, :computer_asset_id
    remove_column :keyserver_computers, :computer_location
    remove_column :keyserver_computers, :computer_owner
    remove_column :keyserver_computers, :computer_confirmed
    remove_column :keyserver_computers, :computer_confirmed_by
    remove_column :keyserver_computers, :computer_notes
    remove_column :keyserver_computers, :computer_flags
    remove_column :keyserver_programs, :program_char_stamp
    remove_column :keyserver_programs, :program_name
    remove_column :keyserver_programs, :program_ai_version
    remove_column :keyserver_programs, :program_version_mask
    remove_column :keyserver_programs, :program_version
    remove_column :keyserver_programs, :program_path
    remove_column :keyserver_programs, :program_file_name
    remove_column :keyserver_programs, :program_keyed
    remove_column :keyserver_programs, :program_acknowledged
    remove_column :keyserver_programs, :program_audit
    remove_column :keyserver_programs, :program_folder_id
    remove_column :keyserver_programs, :program_launch_seen
    remove_column :keyserver_programs, :program_disc_method
    remove_column :keyserver_programs, :program_discovered
    remove_column :keyserver_programs, :program_create_date
    remove_column :keyserver_programs, :program_user_name
    remove_column :keyserver_programs, :program_computer_id
    remove_column :keyserver_programs, :program_notes
    remove_column :keyserver_programs, :program_flags



    change_table :keyserver_computers do |t|
      t.string :computer_id
      t.string :computer_name
      t.string :computer_platform
      t.string :computer_protocol
      t.string :computer_domain
      t.string :computer_description
      t.string :computer_division_id
    end

    change_table :keyserver_programs do |t|
      t.string :program_id
      t.string :program_variant
      t.string :program_variant_name
      t.string :program_variant_version
      t.string :program_platform
      t.string :program_publisher
      t.string :program_status
    end

    create_table :keyserver_status_terms do |t|
      t.string :term_id
      t.string :term_value
      t.string :term_abbreviation
    end

    create_table :keyserver_reason_terms do |t|
      t.string :term_id
      t.string :term_value
      t.string :term_abbreviation
    end

    create_table :keyserver_platform_terms do |t|
      t.string :term_id
      t.string :term_value
      t.string :term_abbreviation
    end

    create_table :keyserver_event_terms do |t|
      t.string :term_id
      t.string :term_value
      t.string :term_abbreviation
    end

    create_table :keyserver_cpu_type_terms do |t|
      t.string :term_id
      t.string :term_value
      t.string :term_abbreviation
    end

    create_table :keyserver_usages do |t|
      t.string :usage_id
      t.string :usage_event
      t.string :usage_user_group
      t.string :usage_division
      t.datetime :usage_when
      t.string :usage_time
      t.datetime :usage_other_time
    end

  end
end

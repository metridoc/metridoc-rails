class CreateKeyserverTables < ActiveRecord::Migration[5.1]
  def change
    create_table :keyserver_product_folders do |t|
      t.integer :prodfolder_id
      t.integer :prodfolder_server_id
      t.string :prodfolder_name
      t.string :prodfolder_color
      t.string :prodfolder_notes
      t.string :prodfolder_flags
    end
    create_table :keyserver_licensed_computers do |t|
      t.string :licensee_id
      t.integer :licensee_server_id
      t.string :licensee_computer_id
      t.string :licensee_policy_id
      t.boolean :licensee_acknowledged
      t.datetime :licensee_last_used
      t.datetime :licensee_lease_date
      t.datetime :licensee_lease_expiration
    end
    create_table :keyserver_products do |t|
      t.string :product_id
      t.integer :product_server_id
      t.string :product_name
      t.string :product_version
      t.string :product_platform
      t.date :product_release_date
      t.integer :product_folder_id
      t.string :product_upgrade_id
      t.string :product_status
      t.string :product_tracked
      t.string :product_publisher
      t.string :product_category
      t.string :product_contact
      t.string :product_contact_address
      t.string :product_defined_by
      t.string :product_notes
      t.string :product_flags
    end
    create_table :keyserver_purchase_orders do |t|
      t.string :order_id
      t.integer :order_server_id
      t.date :order_date
      t.integer :order_folder_id
      t.string :order_recipient
      t.string :order_reseller
      t.string :order_reseller_po
      t.string :order_notes
      t.string :order_flags
    end
    create_table :keyserver_contracts do |t|
      t.integer :contract_id
      t.integer :contract_server_id
      t.string :contract_name
    end
    create_table :keyserver_hotfixes do |t|
      t.string :hotfix_id
      t.integer :hotfix_server_id
      t.string :hotfix_stamp
      t.string :hotfix_name
      t.string :hotfix_version
      t.string :hotfix_platform
      t.string :hotfix_publisher
      t.date :hotfix_create_date
      t.string :hotfix_user_name
      t.string :hotfix_computer_id
      t.string :hotfix_notes
      t.string :hotfix_flags
    end
    create_table :keyserver_purchase_allocations do |t|
      t.integer :allocation_id
      t.integer :allocation_server_id
      t.integer :allocation_purchase_id
      t.integer :allocation_upgrade_id
      t.string :allocation_quantity
      t.string :allocation_flags
    end
    create_table :keyserver_users do |t|
      t.string :user_id
      t.integer :user_server_id
      t.datetime :user_last_login
      t.string :user_computer_id
      t.integer :user_folder_id
      t.integer :user_external_id
      t.string :user_notes
      t.string :user_flags
    end
    create_table :keyserver_computers do |t|
      t.string :computer_id
      t.integer :computer_server_id
      t.string :computer_name
      t.string :computer_user_name
      t.string :computer_platform
      t.string :computer_protocol
      t.string :computer_address
      t.string :computer_domain
      t.string :computer_description
      t.string :computer_virtual_host
      t.string :computer_gmt_offset
      t.string :computer_os_family
      t.string :computer_os_type
      t.string :computer_os_version
      t.string :computer_os_release
      t.date :computer_os_install_date
      t.string :computer_os64_bit
      t.string :computer_cpu_type
      t.integer :computer_cpu_count
      t.string :computer_cpu_clock
      t.string :computer_cpu64_bit
      t.string :computer_hyper_threading
      t.string :computer_multicore
      t.string :computer_capabilities
      t.integer :computer_ram_size
      t.string :computer_ram_type
      t.string :computer_ram_array
      t.integer :computer_disk_size
      t.string :computer_free_space
      t.string :computer_disk_manufacturer
      t.string :computer_disk_model
      t.string :computer_display_width
      t.string :computer_display_height
      t.string :computer_display_depth
      t.string :computer_display_manufacturer
      t.string :computer_display_model
      t.string :computer_display_serial
      t.string :computer_video_manufacturer
      t.string :computer_video_model
      t.integer :computer_vram_size
      t.string :computer_mac_address
      t.string :computer_mac_manufacturer
      t.string :computer_mac_model
      t.string :computer_wireless_address
      t.string :computer_wireless_manufacturer
      t.string :computer_wireless_model
      t.string :computer_mac_array
      t.string :computer_site
      t.string :computer_oem_serial
      t.string :computer_os_serial
      t.string :computer_baseboard_serial
      t.string :computer_system_serial
      t.string :computer_manufacturer
      t.string :computer_model
      t.string :computer_bios_serial
      t.string :computer_bios_model
      t.string :computer_bios_version
      t.string :computer_cdrom_present
      t.string :computer_cdrom_writable
      t.string :computer_cdrom_manufacturer
      t.string :computer_cdrom_model
      t.string :computer_dvd_present
      t.string :computer_dvd_writable
      t.string :computer_sound_manufacturer
      t.string :computer_sound_model
      t.string :computer_lease_expiration
      t.string :computer_last_login
      t.string :computer_last_audit
      t.string :computer_base_audit
      t.string :computer_client_version
      t.string :computer_user_session
      t.string :computer_acknowledged
      t.string :computer_allowed
      t.string :computer_audit
      t.integer :computer_division_id
      t.integer :computer_asset_id
      t.string :computer_location
      t.string :computer_owner
      t.string :computer_confirmed
      t.string :computer_confirmed_by
      t.string :computer_notes
      t.string :computer_flags
    end
    create_table :keyserver_computer_group_members do |t|
      t.integer :member_id
      t.integer :member_server_id
      t.integer :member_computer_id
      t.integer :member_group_id
      t.string :member_acknowledged
      t.string :member_last_used
    end
    create_table :keyserver_policy_folders do |t|
      t.integer :polfolder_id
      t.integer :polfolder_server_id
      t.string :polfolder_name
      t.string :polfolder_color
      t.string :polfolder_notes
      t.string :polfolder_flags
    end
    create_table :keyserver_user_folders do |t|
      t.integer :usrfolder_id
      t.integer :usrfolder_server_id
      t.string :usrfolder_name
      t.string :usrfolder_color
      t.string :usrfolder_notes
      t.string :usrfolder_flags
    end
    create_table :keyserver_purchase_items do |t|
      t.string :purchase_id
      t.integer :purchase_server_id
      t.string :purchase_order_id
      t.string :purchase_name
      t.string :purchase_status
      t.string :purchase_type
      t.string :purchase_entitlement_type
      t.string :purchase_metric
      t.integer :purchase_folder_id
      t.string :purchase_entitlements_per_package
      t.date :purchase_start_date
      t.date :purchase_end_date
      t.date :purchase_renew_date
      t.string :purchase_currency
      t.string :purchase_extended_cost
      t.string :purchase_converted_cost
      t.string :purchase_unit_msrp
      t.string :purchase_unit_price
      t.string :purchase_product_id
      t.string :purchase_effective_product_id
      t.string :purchase_invoice
      t.integer :purchase_division_id
      t.integer :purchase_contract_id
      t.string :purchase_group
      t.string :purchase_site
      t.string :purchase_cost_center
      t.string :purchase_reseller_sku
      t.string :purchase_manufacturer_sku
      t.integer :purchase_external_id
      t.string :purchase_location
      t.string :purchase_reference
      t.string :purchase_conditions
      t.string :purchase_description
      t.string :purchase_notes
      t.string :purchase_flags
    end
    create_table :keyserver_programs do |t|
      t.string :program_id
      t.integer :program_server_id
      t.string :program_variant
      t.string :program_char_stamp
      t.string :program_name
      t.string :program_variant_name
      t.string :program_variant_version
      t.string :program_ai_version
      t.string :program_version_mask
      t.string :program_version
      t.string :program_platform
      t.string :program_publisher
      t.string :program_path
      t.string :program_file_name
      t.string :program_keyed
      t.string :program_status
      t.string :program_acknowledged
      t.string :program_audit
      t.integer :program_folder_id
      t.string :program_launch_seen
      t.string :program_disc_method
      t.datetime :program_discovered
      t.datetime :program_create_date
      t.string :program_user_name
      t.string :program_computer_id
      t.string :program_notes
      t.string :program_flags
    end
    create_table :keyserver_locations do |t|
      t.bigint :location_id
      t.integer :location_server_id
      t.string :location_protocol
      t.string :location_name
      t.string :location_range_begin
      t.string :location_range_end
      t.string :location_allowed
      t.string :location_notes
      t.string :location_flags
    end
    create_table :keyserver_program_folders do |t|
      t.integer :folder_id
      t.integer :folder_server_id
      t.string :folder_name
      t.string :folder_color
      t.string :folder_notes
      t.string :folder_flags
    end
    create_table :keyserver_licensed_users do |t|
      t.integer :licensee_id
      t.integer :licensee_server_id
      t.integer :licensee_user_id
      t.integer :licensee_policy_id
      t.string :licensee_acknowledged
      t.string :licensee_last_used
      t.date :licensee_lease_date
      t.string :licensee_lease_expiration
    end
    create_table :keyserver_purchase_supports do |t|
      t.integer :support_id
      t.integer :support_server_id
      t.integer :support_purchase_id
      t.integer :support_product_id
    end
    create_table :keyserver_computer_divisions do |t|
      t.integer :division_id
      t.integer :division_server_id
      t.string :division_name
      t.string :division_color
      t.string :division_notes
      t.string :division_flags
    end
    create_table :keyserver_purchase_codes do |t|
      t.integer :code_id
      t.integer :code_server_id
      t.integer :code_purchase_id
      t.string :code_value
    end
    create_table :keyserver_purchase_documents do |t|
      t.integer :document_id
      t.integer :document_server_id
      t.integer :document_purchase_id
      t.string :document_name
      t.string :document_url
      t.date :document_date_added
    end
    create_table :keyserver_computer_groups do |t|
      t.integer :group_id
      t.integer :group_server_id
      t.string :group_num_members
      t.string :group_max_members
      t.string :group_notes
      t.string :group_flags
    end
    create_table :keyserver_purchase_folders do |t|
      t.integer :purchfolder_id
      t.integer :purchfolder_server_id
      t.string :purchfolder_name
      t.string :purchfolder_color
      t.string :purchfolder_notes
      t.string :purchfolder_flags
    end
    create_table :keyserver_audits do |t|
      t.string :audit_id
      t.integer :audit_server_id
      t.string :audit_computer_id
      t.string :audit_program_id
      t.integer :audit_size
      t.integer :audit_count
      t.datetime :audit_first_seen
      t.datetime :audit_last_seen
      t.datetime :audit_last_used
      t.string :audit_serial_number
      t.string :audit_path
    end
    create_table :keyserver_policy_products do |t|
      t.string :polprod_id
      t.integer :polprod_server_id
      t.string :polprod_policy_id
      t.string :polprod_product_id
      t.integer :polprod_position
      t.string :polprod_flags
    end
    create_table :keyserver_product_components do |t|
      t.string :component_id
      t.integer :component_server_id
      t.string :component_product_id
      t.string :component_program_variant
      t.string :component_utility
      t.string :component_position
      t.string :component_flags
    end
    create_table :keyserver_servers do |t|
      t.integer :server_id
      t.string :server_type
      t.string :server_name
      t.string :server_computer
      t.string :server_serial_number
      t.string :server_version
      t.string :server_start_time
      t.string :server_gmt_offset
      t.string :server_time_zone
      t.string :server_seats
      t.string :server_full_clients
      t.string :server_floating_sessions
      t.string :server_floating_ratio
      t.string :server_licenses_in_use
      t.string :server_licenses_in_queue
    end
    create_table :keyserver_policies do |t|
      t.string :policy_id
      t.integer :policy_server_id
      t.integer :policy_ref_num
      t.string :policy_name
      t.string :policy_action
      t.string :policy_metric
      t.integer :policy_maximum
      t.string :policy_lease_time
      t.string :policy_status
      t.datetime :policy_expiration
      t.string :policy_options
      t.integer :policy_folder_id
      t.integer :policy_contract_id
      t.string :policy_cost_center
      t.string :policy_message
      t.string :policy_notes
    end
  end
end

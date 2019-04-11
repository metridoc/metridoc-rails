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
    drop_table :keyserver_computers
    drop_table :keyserver_programs



    create_table :keyserver_computers do |t|
      t.string :computer_id
      t.string :computer_name
      t.string :computer_platform
      t.string :computer_protocol
      t.string :computer_domain
      t.string :computer_description
    end

    create_table :keyserver_programs do |t|
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
      t.string :usage_when
      t.string :usage_time
      t.string :usage_other_time
    end

  end
end

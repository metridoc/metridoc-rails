class AlterKeyserverTables < ActiveRecord::Migration[5.1]
  def change
    drop_table :keyserver_product_folders do; end
    drop_table :keyserver_licensed_computers do; end
    drop_table :keyserver_products do; end
    drop_table :keyserver_purchase_orders do; end
    drop_table :keyserver_contracts do; end
    drop_table :keyserver_hotfixes do; end
    drop_table :keyserver_purchase_allocations do; end
    drop_table :keyserver_users do; end
    drop_table :keyserver_computer_group_members do; end
    drop_table :keyserver_policy_folders do; end
    drop_table :keyserver_user_folders do; end
    drop_table :keyserver_purchase_items do; end
    drop_table :keyserver_locations do; end
    drop_table :keyserver_program_folders do; end
    drop_table :keyserver_licensed_users do; end
    drop_table :keyserver_purchase_supports do; end
    drop_table :keyserver_computer_divisions do; end
    drop_table :keyserver_purchase_codes do; end
    drop_table :keyserver_purchase_documents do; end
    drop_table :keyserver_computer_groups do; end
    drop_table :keyserver_purchase_folders do; end
    drop_table :keyserver_audits do; end
    drop_table :keyserver_policy_products do; end
    drop_table :keyserver_product_components do; end
    drop_table :keyserver_servers do; end
    drop_table :keyserver_policies do; end
    drop_table :keyserver_computers do; end
    drop_table :keyserver_programs do; end

    create_table :keyserver_programs do |t|
      t.string :program_id
      t.string :program_variant
      t.string :program_variant_name
      t.string :program_variant_version
      t.string :program_platform
      t.string :program_publisher
      t.string :program_status
    end

    create_table :keyserver_computers do |t|
      t.string :computer_id
      t.string :computer_name
      t.string :computer_platform
      t.string :computer_protocol
      t.string :computer_domain
      t.string :computer_description
      t.string :computer_division_id
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

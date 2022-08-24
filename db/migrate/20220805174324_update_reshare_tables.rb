class UpdateReshareTables < ActiveRecord::Migration[5.2]
  def change
    # Update the patron requests table
    change_table :reshare_patron_requests do |t|
      # Rename the start at column, used in incremental loading
      t.rename :start_at, :last_updated

      # Institutional ID for this interaction
      t.column :origin, :string

      # Patron Information
      t.column :pr_hrid, :string
      t.column :pr_patron_type, :string

      # Requesting Information
      t.column :pr_resolved_req_inst_symbol_fk, :string
      t.column :pr_resolved_pickup_location_fk, :string
      t.column :pr_pickup_location_slug, :string

      # Supplying Information
      t.column :pr_resolved_sup_inst_symbol_fk, :string
      t.column :pr_pick_location_fk, :string
      t.column :pr_pick_shelving_location, :string

      # Bibliographic Information
      t.column :pr_title, :string
      t.column :pr_local_call_number, :string
      t.column :pr_selected_item_barcode, :string
      t.column :pr_oclc_number, :string
      t.column :pr_publisher, :string
      t.column :pr_place_of_pub, :string
      t.column :pr_bib_record, :string

      # Status Information
      t.column :pr_state_fk, :string
      t.column :pr_rota_position, :integer
      t.column :pr_is_requester, :boolean

      # Index on unique column
      t.index :pr_id, unique: true
    end

    # Define reversible behavior
    reversible do |dir|
      dir.up do
        remove_column :reshare_patron_requests, :pr_edition
      end
      dir.down do
        add_column :reshare_patron_requests, :pr_edition, :string
      end
    end

    # Create the symbol table
    create_table :reshare_symbols do |t|
      t.column :last_updated, :datetime
      t.column :origin, :string

      t.column :sym_id, :string
      t.column :sym_version, :string

      t.column :sym_owner_fk, :string
      t.column :sym_symbol, :string

      t.index :sym_id, unique: true
    end

    # Create the patron request rota table
    create_table :reshare_patron_request_rota do |t|
      t.column :last_updated, :datetime
      t.column :origin, :string

      t.column :prr_id, :string
      t.column :prr_version, :string
      t.column :prr_date_created, :datetime
      t.column :prr_last_updated, :datetime

      t.column :prr_rota_position, :integer
      t.column :prr_directory_id_fk, :string
      t.column :prr_patron_request_fk, :string
      t.column :prr_state_fk, :string
      t.column :prr_peer_symbol_fk, :string

      t.column :prr_lb_score, :integer
      t.column :prr_lb_reason, :string

      t.index :prr_id, unique: true
    end

    # Update column in directory entries
    change_table :reshare_directory_entries do |t|
      t.rename :start_at, :last_updated

      t.index [:origin, :de_id], unique: true
    end

    # Add Unique Keys to tables
    add_index :reshare_consortial_views, :cv_patron_request_fk, unique: true

    add_index :reshare_req_overdues, :ro_hrid, unique: true
    add_index :reshare_sup_overdues, [:so_supplier, :so_hrid], unique: true

    add_index :reshare_rtat_reqs, :rtr_hrid, unique: true
    add_index :reshare_rtat_ships, :rts_req_id, unique: true
    add_index :reshare_rtat_recs, :rtre_req_id, unique: true

    add_index :reshare_sup_tat_stats, [
      :stst_req_id,
      :stst_from_status,
      :stst_to_status,
      :stst_message,
      :stst_supplier
    ], unique: true, name: :stst_index
    add_index :reshare_stat_reqs, [:str_supplier, :str_id], unique: true
    add_index :reshare_stat_assis, [:sta_supplier, :sta_req_id], unique: true
    add_index :reshare_stat_fills, [:stf_supplier, :stf_req_id], unique: true
    add_index :reshare_stat_ships, [:sts_supplier, :sts_req_id], unique: true
    add_index :reshare_stat_recs, [:stre_supplier, :stre_req_id], unique: true

  end
end

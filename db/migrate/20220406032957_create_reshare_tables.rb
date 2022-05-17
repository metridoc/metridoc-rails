class CreateReshareTables < ActiveRecord::Migration[5.2]
  def change
    create_table :reshare_patron_requests do |t|
      t.boolean :__cf
      t.datetime :__start
      t.string :__origin
      t.string :pr_id
      t.bigint :pr_version
      t.string :pr_patron_surname
      t.datetime :pr_date_created
      t.string :pr_pub_date
      t.string :pr_edition
      t.string :pr_artnum
      t.string :pr_req_inst_symbol
      t.string :pr_doi
      t.string :pr_isbn
      t.string :pr_information_source
      t.string :pr_bici
      t.string :pr_place_of_pub
      t.string :pr_patron_identifier
      t.string :pr_state_fk
      t.datetime :pr_needed_by
      t.string :pr_volume
      t.string :pr_title_of_component
      t.string :pr_coden
      t.string :pr_num_pages
      t.datetime :pr_delay_performing_action_until
      t.string :pr_stitle
      t.string :pr_patron_reference
      t.string :pr_system_instance_id
      t.string :pr_issue
      t.string :pr_pre_error_status_fk
      t.string :pr_part
      t.boolean :pr_is_requester
      t.string :pr_publisher
      t.string :pr_patron_name
      t.bigint :custom_properties_id
      t.string :pr_sponsor
      t.string :pr_author_of_component
      t.string :pr_last_updated
      t.bigint :pr_rota_position
      t.string :pr_pub_type_fk
      t.string :pr_author
      t.string :pr_service_type_fk
      t.string :pr_issn
      t.string :pr_title
      t.string :pr_start_page
      t.boolean :pr_send_to_patron
      t.string :pr_eissn
      t.string :pr_pubdate_of_component
      t.integer :pr_number_of_retries
      t.string :pr_ssn
      t.boolean :pr_awaiting_protocol_response
      t.string :pr_sici
      t.string :pr_sponsoring_body
      t.string :pr_patron_type
      t.string :pr_quarter
      t.string :pr_sub_title
      t.string :pr_local_call_number
      t.string :pr_pick_location_fk
      t.string :pr_pick_shelving_location
      t.string :pr_sup_inst_symbol
      t.string :pr_peer_request_identifier
      t.string :pr_resolved_req_inst_symbol_fk
      t.string :pr_resolved_sup_inst_symbol_fk
      t.string :pr_hrid
      t.string :pr_bib_record
      t.string :pr_selected_item_barcode
      t.string :pr_patron_email
      t.string :pr_patron_note
      t.string :pr_pref_service_point
      t.string :pr_resolved_patron_fk
      t.boolean :pr_request_to_continue
      t.string :pr_pref_service_point_code
      t.string :pr_resolved_pickup_location_fk
      t.boolean :pr_active_loan
      t.boolean :pr_needs_attention
      t.string :pr_due_date_from_lms
      t.string :pr_parsed_due_date_lms
      t.string :pr_due_date_rs
      t.string :pr_parsed_due_date_rs
      t.boolean :pr_overdue
      t.string :pr_oclc_number
      t.string :pr_cancellation_reason_fk
      t.string :pr_bib_record_id
      t.string :pr_supplier_unique_record_id
      t.string :pr_pickup_location_slug
    end

    create_table :reshare_req_stats do |t|
      t.string   :rs_requester
      t.string   :rs_requester_nice_name
      t.string   :rs_id
      t.string   :rs_req_id
      t.datetime :rs_date_created
      t.string   :rs_from_status
      t.string   :rs_to_status
      t.string   :rs_message
    end

    create_table :reshare_directory_entries do |t|
      t.bigint   :__id
      t.boolean  :__cf
      t.datetime :__start
      t.string   :__origin
      t.string   :de_id
      t.bigint   :version
      t.bigint   :custom_properties_id
      t.string   :de_slug
      t.bigint   :de_foaf_timestamp
      t.string   :de_foaf_url
      t.string   :de_name
      t.string   :de_status_fk
      t.string   :de_desc
      t.string   :de_parent
      t.string   :de_lms_location_code
      t.string   :de_entry_url
      t.string   :de_phone_number
      t.string   :de_email_address
      t.string   :de_contact_name
      t.string   :de_type_rv_fk
      t.bigint   :de_published_last_update
      t.string   :de_branding_url
    end

    create_table :reshare_sup_stats do |t|
      t.string   :ss_supplier
      t.string   :ss_supplier_nice_name
      t.string   :ss_id
      t.string   :ss_req_id
      t.datetime :ss_date_created
      t.string   :ss_from_status
      t.string   :ss_to_status
      t.string   :ss_message
    end

    create_table :reshare_consortial_views do |t|
      t.string   :cv_requester
      t.string   :cv_requester_nice_name
      t.datetime :cv_date_created
      t.datetime :cv_last_updated
      t.string   :cv_supplier_nice_name
      t.string   :cv_patron_request_fk
      t.string   :cv_state_fk
      t.string   :cv_code
    end

    create_table :reshare_req_overdues do |t|
      t.string   :ro_requester
      t.string   :ro_requester_nice_name
      t.string   :ro_hrid
      t.string   :ro_title
      t.string   :ro_requester_sym
      t.text     :ro_requester_url
      t.string   :ro_supplier_sym
      t.string   :ro_req_state
      t.string   :ro_due_date_rs
      t.datetime :ro_return_shipped_date
      t.datetime :ro_last_updated
    end

    create_table :reshare_sup_overdues do |t|
      t.string   :so_supplier
      t.string   :so_supplier_nice_name
      t.string   :so_hrid
      t.string   :so_title
      t.string   :so_requester_sym
      t.text     :so_supplier_url
      t.string   :so_supplier_sym
      t.string   :so_res_state
      t.string   :so_due_date_rs
      t.string   :so_local_call_number
      t.string   :so_item_barcode
      t.datetime :so_last_updated
    end

    create_table :reshare_rtat_reqs do |t|
      t.string   :rtr_requester
      t.string   :rtr_requester_nice_name
      t.string   :rtr_hrid
      t.string   :rtr_title
      t.string   :rtr_call_number
      t.string   :rtr_barcode
      t.string   :rtr_supplier
      t.string   :rtr_supplier_nice_name 
      t.datetime :rtr_date_created
      t.string   :rtr_id
    end

    create_table :reshare_rtat_ships do |t|
      t.string   :rts_requester
      t.datetime :rts_date_created
      t.string   :rts_req_id
      t.string   :rts_from_status
      t.string   :rts_to_status
    end

    create_table :reshare_rtat_recs do |t|
      t.string   :rtre_requester
      t.datetime :rtre_date_created
      t.string   :rtre_req_id
      t.string   :rtre_status
    end
  end
end

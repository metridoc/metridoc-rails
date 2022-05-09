class RemoveSuperfluousColumnsToResharePatronRequests < ActiveRecord::Migration[5.2]
  def change
    remove_column :reshare_patron_requests, :__cf, :boolean
    remove_column :reshare_patron_requests, :__start, :datetime
    remove_column :reshare_patron_requests, :__origin, :string
    remove_column :reshare_patron_requests, :pr_artnum, :string
    remove_column :reshare_patron_requests, :pr_req_inst_symbol, :string
    remove_column :reshare_patron_requests, :pr_doi, :string
    remove_column :reshare_patron_requests, :pr_isbn, :string
    remove_column :reshare_patron_requests, :pr_information_source, :string
    remove_column :reshare_patron_requests, :pr_bici, :string
    remove_column :reshare_patron_requests, :pr_place_of_pub, :string
    remove_column :reshare_patron_requests, :pr_patron_identifier, :string
    remove_column :reshare_patron_requests, :pr_state_fk, :string
    remove_column :reshare_patron_requests, :pr_needed_by, :datetime
    remove_column :reshare_patron_requests, :pr_volume, :string
    remove_column :reshare_patron_requests, :pr_title_of_component, :string
    remove_column :reshare_patron_requests, :pr_coden, :string
    remove_column :reshare_patron_requests, :pr_num_pages, :string
    remove_column :reshare_patron_requests, :pr_delay_performing_action_until, :datetime
    remove_column :reshare_patron_requests, :pr_stitle, :string
    remove_column :reshare_patron_requests, :pr_patron_reference, :string
    remove_column :reshare_patron_requests, :pr_system_instance_id, :string
    remove_column :reshare_patron_requests, :pr_issue, :string
    remove_column :reshare_patron_requests, :pr_pre_error_status_fk, :string
    remove_column :reshare_patron_requests, :pr_part, :string
    remove_column :reshare_patron_requests, :pr_is_requester, :boolean
    remove_column :reshare_patron_requests, :pr_publisher, :string
    remove_column :reshare_patron_requests, :pr_patron_name, :string
    remove_column :reshare_patron_requests, :custom_properties_id, :bigint
    remove_column :reshare_patron_requests, :pr_sponsor, :string
    remove_column :reshare_patron_requests, :pr_author_of_component, :string
    remove_column :reshare_patron_requests, :pr_last_updated, :string
    remove_column :reshare_patron_requests, :pr_rota_position, :bigint
    remove_column :reshare_patron_requests, :pr_pub_type_fk, :string
    remove_column :reshare_patron_requests, :pr_author, :string
    remove_column :reshare_patron_requests, :pr_service_type_fk, :string
    remove_column :reshare_patron_requests, :pr_issn, :string
    remove_column :reshare_patron_requests, :pr_title, :string
    remove_column :reshare_patron_requests, :pr_start_page, :string
    remove_column :reshare_patron_requests, :pr_send_to_patron, :boolean
    remove_column :reshare_patron_requests, :pr_eissn, :string
    remove_column :reshare_patron_requests, :pr_pubdate_of_component, :string
    remove_column :reshare_patron_requests, :pr_number_of_retries, :integer
    remove_column :reshare_patron_requests, :pr_ssn, :string
    remove_column :reshare_patron_requests, :pr_awaiting_protocol_response, :boolean
    remove_column :reshare_patron_requests, :pr_sici, :string
    remove_column :reshare_patron_requests, :pr_sponsoring_body, :string
    remove_column :reshare_patron_requests, :pr_patron_type, :string
    remove_column :reshare_patron_requests, :pr_quarter, :string
    remove_column :reshare_patron_requests, :pr_sub_title, :string
    remove_column :reshare_patron_requests, :pr_local_call_number, :string
    remove_column :reshare_patron_requests, :pr_pick_location_fk, :string
    remove_column :reshare_patron_requests, :pr_pick_shelving_location, :string
    remove_column :reshare_patron_requests, :pr_sup_inst_symbol, :string
    remove_column :reshare_patron_requests, :pr_peer_request_identifier, :string
    remove_column :reshare_patron_requests, :pr_resolved_req_inst_symbol_fk, :string
    remove_column :reshare_patron_requests, :pr_resolved_sup_inst_symbol_fk, :string
    remove_column :reshare_patron_requests, :pr_hrid, :string
    remove_column :reshare_patron_requests, :pr_bib_record, :string
    remove_column :reshare_patron_requests, :pr_selected_item_barcode, :string
    remove_column :reshare_patron_requests, :pr_patron_email, :string
    remove_column :reshare_patron_requests, :pr_patron_note, :string
    remove_column :reshare_patron_requests, :pr_pref_service_point, :string
    remove_column :reshare_patron_requests, :pr_resolved_patron_fk, :string
    remove_column :reshare_patron_requests, :pr_request_to_continue, :boolean
    remove_column :reshare_patron_requests, :pr_pref_service_point_code, :string
    remove_column :reshare_patron_requests, :pr_resolved_pickup_location_fk, :string
    remove_column :reshare_patron_requests, :pr_active_loan, :boolean
    remove_column :reshare_patron_requests, :pr_needs_attention, :boolean
    remove_column :reshare_patron_requests, :pr_due_date_from_lms, :string
    remove_column :reshare_patron_requests, :pr_parsed_due_date_lms, :string
    remove_column :reshare_patron_requests, :pr_due_date_rs, :string
    remove_column :reshare_patron_requests, :pr_parsed_due_date_rs, :string
    remove_column :reshare_patron_requests, :pr_overdue, :boolean
    remove_column :reshare_patron_requests, :pr_oclc_number, :string
    remove_column :reshare_patron_requests, :pr_cancellation_reason_fk, :string
    remove_column :reshare_patron_requests, :pr_bib_record_id, :string
    remove_column :reshare_patron_requests, :pr_supplier_unique_record_id, :string
    remove_column :reshare_patron_requests, :pr_pickup_location_slug, :string







  end
end

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

    create_table :reshare_directory_entry do |t|
      t.string :de_id                    
      t.bigint :version                  
      t.bigint :custom_properties_id     
      t.string :de_slug                  
      t.bigint :de_foaf_timestamp        
      t.string :de_foaf_url              
      t.string :de_name                  
      t.string :de_status_fk             
      t.string :de_desc                  
      t.string :de_parent                
      t.string :de_lms_location_code     
      t.string :de_entry_url             
      t.string :de_phone_number          
      t.string :de_email_address         
      t.string :de_contact_name          
      t.string :de_type_rv_fk            
      t.bigint :de_published_last_update 
      t.string :de_branding_url          
    end

    create_table :reshare_sup_stats do |t|
      t.string :ss_supplier          
      t.string :ss_supplier_nice_name
      t.string :ss_id                
      t.string :ss_req_id            
      t.string :ss_date_created      
      t.string :ss_from_status       
      t.string :ss_to_status         
      t.string :ss_message           
    end
  end
end

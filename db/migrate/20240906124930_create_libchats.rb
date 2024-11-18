class CreateLibchats < ActiveRecord::Migration[7.1]
  def change
    create_table :ss_libchats_flags do |t|
      #Original Table Data
      t.integer :chat_id
      t.string :name 
      t.string :contact_info
      t.string :ip
      t.string :browser
      t.string :operating_system
      t.string :user_agent
      t.string :referrer
      t.string :widget
      t.string :department
      t.string :answerer
      t.datetime :timestamp
      t.integer :wait_time
      t.integer :duration
      t.integer :rating
      t.string :comment
      t.string :user_field_1
      t.string :user_field_2
      t.string :user_field_3
      t.string :initial_question
      t.string :transfer_history
      t.integer :message_count
      t.string :internal_note
      t.string :transcript, null: true
      t.string :tags
      t.integer :ticket_id
      t.integer :ra, null: true
      
      #Flags
      t.integer :fiscal_year
      #t.boolean :visitor_q
      #t.boolean :alumni_q
      #t.boolean :faculty_staff_q
      #t.boolean :student_q
      t.string  :user_type 
      t.float :sentiment_score, null: true
      t.string :sentiment, null: true
      t.integer :newspaper
      t.integer :medium
      t.integer :top_searches
      t.integer :services
      t.integer :account_q
      t.integer :subscription_issues
      t.integer :type_of_search
      t.string  :top_referrer
      
      #Demographics Information
      t.string :statistical_category_1
      t.string :statistical_category_2
      t.string :statistical_category_3
      t.string :statistical_category_4
      t.string :statistical_category_5
      t.string :user_group, default: "Unknown"
      t.string :school, default: "Unknown"
      t.string :penn_id
      t.string :pennkey


      t.index ["chat_id"], unique: true, name: "ss_libchats_chat_id"
    end  
  end
end  

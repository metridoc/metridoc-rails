class CreateLibchats < ActiveRecord::Migration[7.1]
  def change
    create_table :libchats do |t|
      t.integer :chat_id
      t.string :name
      t.string :contact_info
      t.string :ip_address
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
      t.string :transcript
      t.string :tags
      t.integer :ticket_id
      t.integer :ra_transaction_ids
    end  
  end
end  

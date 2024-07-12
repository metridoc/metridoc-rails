class AddLibAnswersToTables < ActiveRecord::Migration[7.1]
  def change
    create_table :ss_libanswers_queues do |t|
      t.integer :queue_id
      t.string :name
      t.string :email_address
      t.integer :number_of_tickets, default: 0
      t.datetime :last_modified

      t.index ["queue_id"], unique: true, name: "ss_libanswers_queue_id"
    end
    
    create_table :ss_libanswers_tickets do |t|
      t.integer :ticket_id # Springshare assigned id
      t.integer :queue_id
      t.datetime :asked_on
      t.text :question
      t.text :details
      t.string :owner # Responsible Librarian
      t.string :source
      t.string :status
      t.string :name # Patron Name
      t.string :email # Patron Email
      t.datetime :last_updated
      t.string :tags
      t.integer :interactions
      t.interval :time_to_first_reply
      t.interval :time_to_close
      # Demographic Information
      t.string :statistical_category_1
      t.string :statistical_category_2
      t.string :statistical_category_3
      t.string :statistical_category_4
      t.string :statistical_category_5
      t.string :user_group, default: "Unknown"
      t.string :school, default: "Unknown"
      t.string :penn_id
      t.string :pennkey

      t.index ["ticket_id"], unique: true, name: "ss_libanswers_ticket_id"
    end

  end
end

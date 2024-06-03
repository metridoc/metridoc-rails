class AddLibcalSpaceBookings < ActiveRecord::Migration[7.1]
  def change
    create_table :ss_libcal_space_locations do |t|
      t.integer :location_id # id
      t.string :location_name
      t.boolean :public
      t.integer :form_id

      t.index ["location_id"], unique: true, name: "ss_libcal_space_location_id"
    end

    create_table :ss_libcal_space_forms do |t|
      t.integer :form_id # id
      t.string :name
      t.json :fields

      t.index ["form_id"], unique: true, name: "ss_libcal_space_form_id"
    end

    create_table :ss_libcal_space_questions do |t|
      t.integer :form_id
      t.integer :question_id # id
      t.string :question_key
      t.string :question_type
      t.boolean :required
      t.string :label
      t.json :options

      t.index ["form_id", "question_key"], unique: true, name: "ss_libcal_space_question_id"
    end

    create_table :ss_libcal_space_bookings do |t|
      t.string :booking_key
      t.integer :booking_id
      t.integer :location_id
      t.string :location_name
      t.integer :category_id
      t.string :category_name
      t.integer :item_id
      t.string :item_name
      t.datetime :from_date
      t.datetime :to_date
      t.datetime :created
      t.string :status
      t.datetime :cancelled
      t.json :event
      t.string :nickname
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :account
      t.string :statistical_category_1
      t.string :statistical_category_2
      t.string :statistical_category_3
      t.string :statistical_category_4
      t.string :statistical_category_5
      t.string :user_group
      t.string :school
      t.string :penn_id
      t.string :pennkey
      t.json :answers
      t.datetime :downloaded_at

      t.index ["booking_id"], unique: true, name: "ss_libcal_space_booking_id"

    end

    create_table :ss_libcal_space_answers do |t|
      t.integer :booking_id
      t.string :question_key
      t.string :answer

      t.index ["booking_id", "question_key"], unique: true, name: "ss_libcal_space_answer_id"
    end

  end
end

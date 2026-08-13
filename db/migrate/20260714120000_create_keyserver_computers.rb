class CreateKeyserverComputers < ActiveRecord::Migration[7.2]
  def change
    create_table :keyserver_computers do |t|
      t.string :computer_name, null: false
      t.string :location
      t.string :section
      t.timestamps null: true
    end

    add_index :keyserver_computers, :computer_name, unique: true
  end
end

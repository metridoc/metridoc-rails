class CreateComputerDivisionsTable < ActiveRecord::Migration[5.1]
  def change

    drop_table :keyserver_computers

    create_table :computer_divisions do |t|
      t.string :division_id
      t.string :division_server_id
      t.string :division_name
      t.string :division_section_id
      t.string :division_notes
      t.string :division_flags
    end

    create_table :keyserver_computers do |t|
      t.string :computer_id
      t.string :computer_name
      t.string :computer_platform
      t.string :computer_protocol
      t.string :computer_domain
      t.string :computer_division_id
    end

  end
end

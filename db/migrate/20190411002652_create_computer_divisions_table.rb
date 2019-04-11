class CreateComputerDivisionsTable < ActiveRecord::Migration[5.1]
  def change
    create_table :computer_divisions do |t|
      t.string :division_id
      t.string :division_server_id
      t.string :division_name
      t.string :division_section_id
      t.string :division_notes
      t.string :division_flags
    end
  end
end

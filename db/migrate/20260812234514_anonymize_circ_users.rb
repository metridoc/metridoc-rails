class AnonymizeCircUsers < ActiveRecord::Migration[7.2]
  def up
    remove_column :alma_circulations, :penn_id_number
    rename_column :alma_circulations, :pseudonym, :penn_id_number
  end

  def down
    rename_column :alma_circulations, :penn_id_number, :pseudonym
    add_column :alma_circulations, :penn_id_number, :integer
  end
end

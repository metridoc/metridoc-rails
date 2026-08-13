class AlterAlmaCirculation < ActiveRecord::Migration[7.2]
  def up
    add_column :alma_circulations, :pseudonym, :string
    add_index :alma_circulations, :pseudonym

    remove_column :alma_circulations, :user_id
    remove_column :alma_circulations, :preferred_email
  end

  def down
    remove_column :alma_circulations, :pseudonym

    add_column :alma_circulations, :user_id, :integer
    add_column :alma_circulations, :preferred_email, :string
  end
end

class AddPersonalInformationToAlmaCirculations < ActiveRecord::Migration[5.2]
  def change
    add_column :alma_circulations, :first_name, :string
    add_column :alma_circulations, :last_name, :string
    add_column :alma_circulations, :preferred_email, :string
    add_column :alma_circulations, :penn_id_number, :integer
  end
end

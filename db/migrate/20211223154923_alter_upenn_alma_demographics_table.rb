class AlterUpennAlmaDemographicsTable < ActiveRecord::Migration[5.2]
  def change
    add_column :upenn_alma_demographics, :penn_id, :text, :limit => 8
    add_column :upenn_alma_demographics, :first_name, :text
    add_column :upenn_alma_demographics, :last_name, :text
    add_column :upenn_alma_demographics, :email, :text
    add_column :upenn_alma_demographics, :user_group, :text
    rename_column :upenn_alma_demographics, :identifier_value, :pennkey
  end
end

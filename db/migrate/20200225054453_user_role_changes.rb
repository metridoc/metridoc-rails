class UserRoleChanges < ActiveRecord::Migration[5.1]
  def change
    create_table :user_roles do |t|
      t.string     :name, null: false
      t.timestamps null: false
    end

    add_column :admin_users, :super_admin, :boolean, null: false, default: false
    add_column :admin_users, :user_role_id, :integer
    add_foreign_key :admin_users, :user_roles

    create_table :user_role_sections do |t|
      t.belongs_to :user_role, null: false
      t.string     :section, null: false
      t.string     :access_level, null: false # read-only, edit
      t.timestamps null: false
    end
    add_foreign_key :user_role_sections, :user_roles

  end
end

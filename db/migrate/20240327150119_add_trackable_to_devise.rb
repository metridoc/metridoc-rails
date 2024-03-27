class AddTrackableToDevise < ActiveRecord::Migration[7.1]
  def change
    add_column :admin_users, :sign_in_count, :integer, default: 0, null: false
    add_column :admin_users, :current_sign_in_at, :datetime
    add_column :admin_users, :last_sign_in_at, :datetime
  end
end

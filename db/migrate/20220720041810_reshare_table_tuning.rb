class ReshareTableTuning < ActiveRecord::Migration[5.2]
  def change
    add_column :reshare_patron_requests, :start_at, :datetime
    add_column :reshare_directory_entries, :start_at, :datetime
  end
end

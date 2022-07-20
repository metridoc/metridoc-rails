class ReshareTableTuning < ActiveRecord::Migration[5.2]
  def change
    add_column :reshare_patron_requests, :__start, :datetime
    add_column :reshare_directory_entries, :__start, :datetime
  end
end

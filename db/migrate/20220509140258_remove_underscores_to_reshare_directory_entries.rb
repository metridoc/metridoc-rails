class RemoveUnderscoresToReshareDirectoryEntries < ActiveRecord::Migration[5.2]
  def change
    remove_column :reshare_directory_entries, :__id, :bigint
    remove_column :reshare_directory_entries, :__cf, :boolean
    remove_column :reshare_directory_entries, :__start, :datetime
    rename_column :reshare_directory_entries, :__origin, :origin
  end
end

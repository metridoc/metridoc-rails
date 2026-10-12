class Keyserver::Session < Keyserver::Base

  def self.superadmin_columns = [:username, :computer_name]

  # Re-uploading a file that overlaps existing data is safe: rows matching the
  # natural key are left untouched rather than raising a uniqueness error.
  def self.on_conflict_update
    {
      conflict_target: [:computer_name, :username, :start_time],
      columns: [:end_time, :duration]
    }
  end

  # When a sessions file is imported, make sure to update the views built on it.
  def self.update_after_import
    Scenic.database.refresh_materialized_view(:keyserver_concurrent_sessions, concurrently: true)
    Scenic.database.refresh_materialized_view(:keyserver_occupancies, concurrently: true)
  end
end

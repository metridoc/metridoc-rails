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
end

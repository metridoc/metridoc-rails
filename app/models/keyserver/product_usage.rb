class Keyserver::ProductUsage < Keyserver::Base
  # Represents a single product record (one row per software product).
  def self.on_conflict_update
    {
      conflict_target: [:ident, :start_time],
      columns: [:duration, :foreground, :program_name]
    }
  end
end
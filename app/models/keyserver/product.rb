class Keyserver::Product < Keyserver::Base
  # Represents a single product record (one row per software product).
  def self.on_conflict_update
    {
      conflict_target: [:ident],
      columns: Keyserver::Product.column_names - ["id", "ident"]
    }
  end
end
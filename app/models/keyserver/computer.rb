class Keyserver::Computer < Keyserver::Base
  def self.on_conflict_update
    {
      conflict_target: [:ident],
      columns: Keyserver::Computer.column_names - ["id", "ident"]
    }
  end
end

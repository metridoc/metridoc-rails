class Keyserver::Report < Keyserver::Base
  # List of reports available in the Keyserver folder.
  def self.on_conflict_update
    {
      conflict_target: [:ident],
      columns: column_names - ["id", "ident"]
    }
  end
end
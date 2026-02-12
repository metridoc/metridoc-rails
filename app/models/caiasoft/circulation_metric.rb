class Caiasoft::CirculationMetric < Caiasoft::Base

  def self.on_conflict_update
    {
      conflict_target: [:item_retrieved, :request_id, :job],
      columns: self.column_names.map(&:to_sym) - [:id, :item_retrieved, :request_id, :job]
    }
  end

end

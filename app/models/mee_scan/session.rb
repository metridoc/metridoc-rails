class MeeScan::Session < MeeScan::Base

  def self.on_conflict_update
    {
      conflict_target: [:created_at, :name, :item_count, :kiosk_id],
      columns: []
    }
  end

end

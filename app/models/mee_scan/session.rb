class MeeScan::Session < MeeScan::Base

  # TODO: This conflict key cannot distinguish two legitimate sessions logged in
  # the same second on the same kiosk (they differ only by e.g. app_version).
  # When an upload batch contains such a pair, Postgres raises "ON CONFLICT DO
  # UPDATE command cannot affect row a second time" and the import stalls.
  # Durable fix: widen the conflict key (e.g. add :app_version) or de-dupe each
  # batch before the upsert in Tools::FileUploadImport#import_records, so uploaders
  # don't have to hand-nudge duplicate timestamps.
  def self.on_conflict_update
    {
      conflict_target: [:created_at, :name, :item_count, :kiosk_id],
      columns: []
    }
  end

end

class Caiasoft::DeaccessionInfo < Caiasoft::Base

  def self.on_conflict_update
    {
      conflict_target: [:barcode, :job],
      columns: self.column_names.map(&:to_sym) - [:id, :barcode, :job]
    }
  end

end

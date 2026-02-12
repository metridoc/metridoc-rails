class Caiasoft::AccessionInfo < Caiasoft::Base

  def self.on_conflict_update
    {
      conflict_target: [:barcode, :accession_date, :accession_type],
      columns: self.column_names.map(&:to_sym) - [:id, :barcode, :accession_date, :accession_type]
    }
  end

end

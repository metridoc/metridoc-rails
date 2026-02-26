class Ipeds::Cipcode < Ipeds::Base
  
  # Define rules for updating on conflict
  def self.conflict_id
    [:cip_code2010, :cip_code2020]
  end

  def self.columns_to_update
    self.column_names.map(&:to_sym) - self.conflict_id.push(:id)
  end

  # Define rules for updating on conflict
  def self.on_conflict_update
    {
      conflict_target: self.conflict_id,
      columns: self.columns_to_update
    }
  end

end

class Ipeds::Cipcode < Ipeds::Base
  
  # Define rules for updating on conflict
  def self.on_conflict_update
    ["cip_code2010", "cip_code2020"]
  end

end

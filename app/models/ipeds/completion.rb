class Ipeds::Completion < Ipeds::Base
  
  # Define rules for updating on conflict
  def self.on_conflict_update
    ["year", "unitid", "cipcode", "majornum", "awlevel"]
  end
  
end

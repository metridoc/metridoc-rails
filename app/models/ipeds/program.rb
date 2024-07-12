class Ipeds::Program < Ipeds::Base

  # Define rules for updating on conflict
  def self.on_conflict_update
    ["year", "unitid", "cipcode"]
  end

end

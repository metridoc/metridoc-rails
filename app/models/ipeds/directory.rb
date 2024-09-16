class Ipeds::Directory < Ipeds::Base

  # Define rules for updating on conflict
  def self.on_conflict_update
    ["unitid"]
  end

end

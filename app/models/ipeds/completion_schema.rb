class Ipeds::CompletionSchema < Ipeds::Base

  # Define rules for updating on conflict
  def self.on_conflict_update
    ["varname"]
  end

end

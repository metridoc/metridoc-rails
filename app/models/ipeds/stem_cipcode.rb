class Ipeds::StemCipcode < Ipeds::Base

  # Define rules for updating on conflict
  def self.on_conflict_update
    ["cip_code_2020"]
  end

end

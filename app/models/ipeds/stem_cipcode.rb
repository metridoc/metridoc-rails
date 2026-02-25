class Ipeds::StemCipcode < Ipeds::Base

  # Define rules for updating on conflict
  def self.on_conflict_update
    {
      conflict_target: [:cip_code_2020],
      columns: [
        :cip_code_two_digit_series,
        :cip_code_title
      ]
    }
  end

end

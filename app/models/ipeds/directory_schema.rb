class Ipeds::DirectorySchema < Ipeds::Base

  # Define rules for updating on conflict    
  def self.on_conflict_update
    {
      conflict_target: [:varname],
      columns: [
        :data_type,
        :fieldwidth,
        :format,
        :imputationvar,
        :var_title
      ]
    }
  end

end

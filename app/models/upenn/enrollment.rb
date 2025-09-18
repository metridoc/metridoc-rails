class Upenn::Enrollment < Upenn::Base
  def self.on_conflict_update
    {
      conflict_target: [:user_type, :school, :fiscal_year],
      columns: [
        :value,
        :user_parent,
        :school_parent
      ]
    }
  end
end

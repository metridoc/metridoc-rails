# app/services/keyserver/program_activity_summary.rb

module Keyserver
  class ProgramActivitySummary
    def initialize(scope)
      @scope = scope
    end
    
    def call
      @scope
        .group(:program_name)
        .select(
          :program_name,
          "COUNT(DISTINCT user_name) AS unique_users", 
          "COUNT(DISTINCT computer_name) AS computers_used", 
          "COUNT(*) AS sessions", 
          "AVG(duration) AS avg_duration", 
          "MAX(start_time) AS most_recent_use"
        )
        .order(:program_name)
        .to_a
    end
  end
end
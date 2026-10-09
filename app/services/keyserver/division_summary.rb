# app/services/keyserver/division_summary.rb
module Keyserver
  class DivisionSummary
    def initialize(scope, start_date:, end_date:)
      @scope = scope
      @start_date = start_date
      @end_date = end_date
    end

    def call
      {
        records:   session_records,
        available: available_computers,
        peak_usage: peak_usage
      }
    end

    private

    def session_records
      @scope
        .group(:division)
        .select(
          :division,
          "COUNT(DISTINCT user_name)    AS unique_users",
          "COUNT(DISTINCT computer_name) AS computers_used",
          "COUNT(computer_name)          AS sessions",
          "AVG(duration)                 AS avg_duration"
        )
    end

    def available_computers
      Keyserver::Computer.group(:division).count
    end

    def peak_usage
      Keyserver::ConcurrentSession
        .where(session_date: @start_date..@end_date)
        .group(:division)
        .maximum(:peak_sessions)
    end
  end
end
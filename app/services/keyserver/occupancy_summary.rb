# app/services/keyserver/occupancy_summary.rb
module Keyserver
  class OccupancySummary
    DAYS  = (0..6).to_a.freeze
    HOURS = (0..23).to_a.freeze

    def initialize(scope)
      @scope = scope
    end

    def call
      grouped = @scope.group_by do |record|
        utc_time = Time.parse("#{record.date} #{record.hour_of_day.to_i}:00:00 UTC")
        eastern_time = utc_time.in_time_zone('America/New_York')
        [eastern_time.wday, eastern_time.hour]
      end

      n_computers = build_n_computer_matrix(grouped)
      n_weeks = build_n_weeks_matrix(grouped)

      {
        avg_fleet_sessions:         build_result(grouped, :avg_fleet_sessions, n_computers, n_weeks),
        avg_sessions_per_computer:  build_result(grouped, :avg_sessions_per_computer, n_computers, n_weeks),
        avg_occupancy_per_computer: build_result(grouped, :avg_occupancy_per_computer, n_computers, n_weeks)
      }
    end

    private

    def build_empty_matrix
      DAYS.each_with_object({}) do |day, matrix|
        matrix[day] = HOURS.each_with_object({}) do |hour, row|
          row[hour] = { value: 0 }
        end
      end
    end

    def build_n_computer_matrix(grouped)
      n_computers = build_empty_matrix
      DAYS.each do |day|
        HOURS.each do |hour|
          records = grouped[[day, hour]] || []
          value = records.empty? ? 1 : avg_available_computers(records)
          n_computers[day][hour] = value
        end
      end
      n_computers
    end

    def build_n_weeks_matrix(grouped)
      n_weeks = build_empty_matrix
      DAYS.each do |day|
        HOURS.each do |hour|
          records = grouped[[day, hour]] || []
          value = records.empty? ? 1 : records.map(&:date).uniq.size
          n_weeks[day][hour] = value
        end
      end
      n_weeks
    end

    def build_result(grouped, metric, n_computers, n_weeks)
      matrix  = build_empty_matrix
      max_cnt = 0

      DAYS.each do |day|
        HOURS.each do |hour|
          records = grouped[[day, hour]] || []
          value   = records.empty? ? 0 : send(
            metric, 
            records, 
            n_computers[day][hour], 
            n_weeks[day][hour]
          )

          matrix[day][hour] = { value: value }
          max_cnt = [value, max_cnt].max
        end
      end

      { matrix: matrix, max_cnt: max_cnt }
    end

    # For a given [day_of_week, hour_of_day] slot:
    # Each date may have a different computers_per_division
    def avg_available_computers(records)
      totals_per_date = records
        .group_by(&:date)
        .map do |_date, date_records|
          date_records
            .group_by(&:division)
            .sum { |_, div_records| div_records.first.computers_per_division.to_f }
        end

      avg_computers = totals_per_date.sum / totals_per_date.size
      [avg_computers, 1.0].max
    end

    # Total sessions across all computers, averaged over weeks
    # Answers: "How busy is this time slot for the whole fleet?"
    def avg_fleet_sessions(records, n_computers, n_weeks)
      total   = records.sum { |r| r.total_active_sessions.to_f }
      total / n_weeks
    end

    # Sessions per individual computer, averaged over weeks
    # Answers: "How many sessions does the average computer handle?"
    def avg_sessions_per_computer(records, n_computers, n_weeks)
      total   = records.sum { |r| r.total_active_sessions.to_f }
      total / (n_weeks * n_computers)
    end

    # Fraction of each hour the average computer is in use
    # Answers: "What fraction of capacity is in use at this time?"
    def avg_occupancy_per_computer(records, n_computers, n_weeks)
      total       = records.sum { |r| r.occupancy.to_f }
      total / (n_weeks * n_computers)
    end
  end
end
# app/services/keyserver/demographic_matrix.rb
module Keyserver
  class DemographicMatrix
    UNKNOWN = "Unknown"

    def initialize(scope)
      @scope = scope
    end

    # Allows the class to call distinct or raw counts.
    def call
      {
        distinct: build_matrix(fetch_counts(distinct: true)),
        raw:      build_matrix(fetch_counts(distinct: false))
      }
    end

    private

    def fetch_counts(distinct:)
      if distinct
        @scope.group(:user_group, :school).distinct.count(:user_name)
      else
        @scope.group(:user_group, :school).count(:user_name)
      end
    end

    def build_empty_matrix
      user_groups = REVERSE_USER_GROUP_MAP.keys
      user_groups += [UNKNOWN] unless user_groups.include?(UNKNOWN)

      schools = REVERSE_SCHOOL_MAP.keys
      schools += [UNKNOWN] unless schools.include?(UNKNOWN)

      user_groups.each_with_object({}) do |user_group, matrix|
        matrix[user_group] = schools.each_with_object({}) do |school, hash|
          hash[school] = { value: 0 }
        end
      end
    end

    def build_matrix(raw_counts)
      matrix  = build_empty_matrix
      max_cnt = 0

      raw_counts.each do |(user_group, school), count|
        mapped_group  = USER_GROUP_MAP[user_group] || UNKNOWN
        mapped_school = SCHOOL_MAP[school]         || UNKNOWN
        cell = matrix[mapped_group][mapped_school]
        cell[:value] += count
        next if mapped_group == UNKNOWN && mapped_school == UNKNOWN
        max_cnt = [cell[:value], max_cnt].max
      end

      { matrix: matrix, max_cnt: max_cnt }
    end
  end
end
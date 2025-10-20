class Upenn::AcademicCalendar < Upenn::Base
  def self.on_conflict_update
    {
      conflict_target: [:fiscal_year, :term],
      columns: [
        :start_date,
        :end_date,
        :calendar_year
      ]
    }
  end
end

class AddDayOfWeekAndHourOfDayToMeescanSessions < ActiveRecord::Migration[7.2]
  def change
    add_column :meescan_sessions, :day_of_week, :string
    add_column :meescan_sessions, :hour_of_day, :integer
  end
end

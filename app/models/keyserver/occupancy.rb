# app/models/keyserver/occupancy.rb
class Keyserver::Occupancy < Keyserver::Base
  # Non-standard composite primary key setup
  self.primary_key = [:computer_name, :date, :hour_of_day]

  def readonly?
    true
  end
end
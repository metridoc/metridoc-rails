class Circulation::PickUpRequest < Circulation::Base
  def self.last_week
    4.weeks.ago.beginning_of_week..4.weeks.ago.end_of_week
  end

  def self.format_date_range(date_range: last_week)
    "#{date_range.begin.strftime("%Y-%m-%d")} to #{date_range.end.strftime("%Y-%m-%d")}"
  end

  def self.gather_data(date_range: last_week)
    local_processed_values = Circulation::PickUpRequest.where(:date => date_range).order(:location).group(:location).sum(:local_processed)
    values = Circulation::PickUpRequest.where(:date => date_range).order(:location).group(:location).pluck(:location, "SUM(received)", "SUM(local_processed)", "SUM(offsite_processed)", "SUM(abandoned)")
    combined_values = { }
    values.each do |value|
      location = value[0]
      combined_values[location] ||= {}
      combined_values[location]["Received"] = value[1]
      combined_values[location]["Processed Locally"] = value[2]
      combined_values[location]["Processed Off Site"] = value[3]
      combined_values[location]["Not Picked Up"] = value[4]
    end
    combined_values.map{ |key,value| {name: key, data: value} }
  end
end
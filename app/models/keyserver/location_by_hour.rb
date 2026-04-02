class Keyserver::LocationByHour < Keyserver::Base
  # Read-only view: session counts per location per hour of day (8–22).
  # ROW_NUMBER() provides a stable synthetic id.
  # See db/views/keyserver_location_by_hours_v01.sql.

  def readonly?
    true
  end
end

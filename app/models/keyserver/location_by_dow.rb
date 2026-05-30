class Keyserver::LocationByDow < Keyserver::Base
  # Read-only view: session counts per location per day of week (0=Sun–6=Sat),
  # business hours only. ROW_NUMBER() provides a stable synthetic id.
  # See db/views/keyserver_location_by_dows_v01.sql.

  DAY_NAMES = %w[Sun Mon Tue Wed Thu Fri Sat].freeze

  def readonly?
    true
  end
end

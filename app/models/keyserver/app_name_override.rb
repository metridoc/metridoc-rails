class Keyserver::AppNameOverride < Keyserver::Base
  # Maps a raw Keyserver application string to a preferred canonical name,
  # taking precedence over the normalize_app_name() PostgreSQL function's
  # regex-based stripping.
  #
  # Example:
  #   raw_name:  "ArcGIS Pro (x64) - 3.2.0"
  #   canonical: "ArcGIS Pro"
  #
  # To add an override, insert a row directly or via a seed/fixture.
  # The normalize_app_name() function checks this table first.

  validates :raw_name,  presence: true, uniqueness: true
  validates :canonical, presence: true
end

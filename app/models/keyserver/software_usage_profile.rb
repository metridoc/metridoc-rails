class Keyserver::SoftwareUsageProfile < Keyserver::Base
  # Read-only view: one row per managed product with checkout metrics and
  # an activity status (Active / Stale / Dormant) relative to the dataset ceiling.
  # See db/views/keyserver_software_usage_profiles_v01.sql.

  self.primary_key = :product

  STATUS_ORDER = { "Active" => 0, "Stale" => 1, "Dormant" => 2 }.freeze

  scope :active,  -> { where(status: "Active") }
  scope :stale,   -> { where(status: "Stale") }
  scope :dormant, -> { where(status: "Dormant") }
  scope :non_active, -> { where(status: %w[Stale Dormant]) }

  def readonly?
    true
  end
end

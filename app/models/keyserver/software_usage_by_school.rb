class Keyserver::SoftwareUsageBySchool < Keyserver::Base
  # Read-only view: checkout counts per product per Alma school.
  # Rows with school = NULL represent users whose user_name is not a pennkey
  # (i.e. cannot be joined to upenn_alma_demographics).
  # See db/views/keyserver_software_usage_by_schools_v01.sql.

  def readonly?
    true
  end
end

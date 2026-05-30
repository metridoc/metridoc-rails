class Keyserver::SoftwareUsageByUserGroup < Keyserver::Base
  # Read-only view: checkout counts per product per Alma user_group.
  # Rows with user_group = NULL represent non-pennkey users.
  # See db/views/keyserver_software_usage_by_user_groups_v01.sql.

  def readonly?
    true
  end
end

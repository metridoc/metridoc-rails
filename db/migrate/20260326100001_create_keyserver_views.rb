class CreateKeyserverViews < ActiveRecord::Migration[7.0]
  def change
    create_view :keyserver_non_staff_computers
    create_view :keyserver_software_usage_profiles
    create_view :keyserver_location_by_hours
    create_view :keyserver_location_by_dows
    create_view :keyserver_software_usage_by_schools
    create_view :keyserver_software_usage_by_user_groups
  end
end

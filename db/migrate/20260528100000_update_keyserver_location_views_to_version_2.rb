class UpdateKeyserverLocationViewsToVersion2 < ActiveRecord::Migration[7.2]
  def up
    drop_view :keyserver_location_by_hours
    create_view :keyserver_location_by_hours, version: 2
    drop_view :keyserver_location_by_dows
    create_view :keyserver_location_by_dows, version: 2
  end

  def down
    drop_view :keyserver_location_by_hours
    create_view :keyserver_location_by_hours, version: 1
    drop_view :keyserver_location_by_dows
    create_view :keyserver_location_by_dows, version: 1
  end
end

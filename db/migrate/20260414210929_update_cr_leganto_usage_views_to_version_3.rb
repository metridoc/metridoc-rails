class UpdateCrLegantoUsageViewsToVersion3 < ActiveRecord::Migration[7.2]
  def up
    drop_view :cr_leganto_usage_views
    create_view :cr_leganto_usage_views, version: 3
  end

  def down
    drop_view :cr_leganto_usage_views
    create_view :cr_leganto_usage_views, version: 2
  end
end

class UpdateCrLegantoUsageViewsToVersion3 < ActiveRecord::Migration[7.2]
  def change
    update_view :cr_leganto_usage_views, version: 3, revert_to_version: 2
  end
end

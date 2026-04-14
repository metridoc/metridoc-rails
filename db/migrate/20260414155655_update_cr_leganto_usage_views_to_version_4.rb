class UpdateCrLegantoUsageViewsToVersion4 < ActiveRecord::Migration[7.2]
  def change
    update_view :cr_leganto_usage_views, version: 4, revert_to_version: 3
  end
end

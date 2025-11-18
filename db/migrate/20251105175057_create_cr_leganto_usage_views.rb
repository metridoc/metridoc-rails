class CreateCrLegantoUsageViews < ActiveRecord::Migration[7.1]
  def change
    create_view :cr_leganto_usage_views
  end
end

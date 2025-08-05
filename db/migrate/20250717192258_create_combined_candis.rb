class CreateCombinedCandis < ActiveRecord::Migration[7.1]
  def change
    create_view :candi_views
  end
end

class CreateLibchatCombineds < ActiveRecord::Migration[7.1]
  def change
    create_view :ss_libchat_combined_views
  end
end

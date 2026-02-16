class UnifyDatabase < ActiveRecord::Migration[7.2]
  def up
    # Add precision into active admin comments datetimes
    change_column :active_admin_comments, :created_at, :datetime, precision: nil, null: false
    change_column :active_admin_comments, :updated_at, :datetime, precision: nil, null: false

    # Rename indices in active admin comments to match with updated 7.2 schema
    if index_exists?(:active_admin_comments, :author_type, :author_id, name: 'index_active_admin_comments_on_author_type_and_author_id')
      rename_index :active_admin_comments, 'index_active_admin_comments_on_author_type_and_author_id', 'index_active_admin_comments_on_author' 
    end

    if index_exists?(:active_admin_comments, :resource_type, :resource_id, name: 'index_active_admin_comments_on_resource_type_and_resource_id')
      rename_index :active_admin_comments, 'index_active_admin_comments_on_resource_type_and_resource_id', 'index_active_admin_comments_on_resource' 
    end

  end

  def down
    # Add precision into active admin comments datetimes
    change_column :active_admin_comments, :created_at, :datetime, null: false
    change_column :active_admin_comments, :updated_at, :datetime, null: false

    # Rename indices in active admin comments to match with updated 7.2 schema
    if index_exists?(:active_admin_comments, :author_type, :author_id, name: 'index_active_admin_comments_on_author')
      rename_index :active_admin_comments, 'index_active_admin_comments_on_author', 'index_active_admin_comments_on_author_type_and_author_id' 
    end

    if index_exists?(:active_admin_comments, :resource_type, :resource_id, name: 'index_active_admin_comments_on_resource')
      rename_index :active_admin_comments, 'index_active_admin_comments_on_resource', 'index_active_admin_comments_on_resource_type_and_resource_id' 
    end

  end

  def change
    # Ensure the extension is enabled
    enable_extension 'pgstattuple'
  end
end

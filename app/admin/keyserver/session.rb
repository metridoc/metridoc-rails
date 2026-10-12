ActiveAdmin.register Keyserver::Session,
namespace: :keyserver do
  menu false

  breadcrumb do
    [
      link_to('Keyserver', :keyserver_root)
    ]
  end

  actions :all, :except => [:new, :edit, :update, :destroy]

  preserve_default_filters!
  Keyserver::Session.superadmin_columns.each do |c|
    remove_filter c.to_sym
  end

  # Set the title on the index page
  index title: "Sessions", download_links: [:csv] do

    id_column
    # Loop through the columns and hide it if not super admin
    self.resource_class.column_names.each do |c|
      next if c == "id"
      next if (
        self.resource_class.superadmin_columns.include?(c) && 
        !current_admin_user.super_admin?
      )

      next column c.to_sym unless c == "duration"

      column :duration do |session|
        ActiveSupport::Duration.build(session.duration).iso8601
      end

    end

    actions
  end

  show title: :id do
    attributes_table do
      # Loop through the columns and hide it if not super admin
      self.resource_class.column_names.each do |c|

        next if (
          self.resource_class.superadmin_columns.include?(c) && 
          !current_admin_user.super_admin?
        )

        row c.to_sym
      end
    end
  end

  csv do

    # Loop through the columns and hide it if not super admin
    self.resource_class.column_names.each do |c|
      next if (
        self.resource_class.superadmin_columns.include?(c) &&
        !current_admin_user.super_admin?
      )
      column c.to_sym
    end
    
  end

end

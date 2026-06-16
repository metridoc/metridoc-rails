ActiveAdmin.register Keyserver::Event,
namespace: :keyserver do
  menu false

  breadcrumb do
    [
      link_to('Keyserver', :keyserver_root)
    ]
  end

  actions :all, :except => [:new, :edit, :update, :destroy]

  # Don't expose super-admin-only columns (user_name) through the filter sidebar.
  preserve_default_filters!
  Keyserver::Event.superadmin_columns.each do |c|
    remove_filter c.to_sym
  end

  index title: "Events" do
    id_column
    # Show each column, hiding super-admin-only columns from non-super-admins.
    self.resource_class.column_names.each do |c|
      next if c == "id"
      next if self.resource_class.superadmin_columns.map(&:to_s).include?(c) && !current_admin_user.super_admin?

      column c.to_sym
    end
    actions
  end

  show do
    attributes_table do
      self.resource_class.column_names.each do |c|
        next if self.resource_class.superadmin_columns.map(&:to_s).include?(c) && !current_admin_user.super_admin?

        row c.to_sym
      end
    end
  end
end

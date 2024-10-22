ActiveAdmin.register Springshare::Libanswers::Ticket,
as: "Libanswers::Ticket",
namespace: :springshare do
  menu false

  breadcrumb do
    # Custom breadcrumb links
    [
      link_to('Springshare', :springshare_root),
      link_to('LibAnswers', :springshare_libanswers)
    ]
  end

  actions :all, :except => [:new, :edit, :update, :destroy]

  preserve_default_filters!
  Springshare::Libanswers::Ticket.superadmin_columns.each do |c|
    remove_filter c.to_sym
  end

  # Set the title on the index page
  index title: "Tickets", download_links: [:csv] do

    id_column
    # Loop through the columns and hide it if not super admin
    self.resource_class.column_names.each do |c|
      next if c == "id"
      next if (
        self.resource_class.superadmin_columns.include?(c) && 
        !current_admin_user.super_admin?
      )

      column c.to_sym
    end
    actions
  end

  show do
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
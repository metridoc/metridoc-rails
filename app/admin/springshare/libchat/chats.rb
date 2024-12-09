ActiveAdmin.register Springshare::Libchat::Chat,
as: "Libchat::Chat",
namespace: :springshare do
  menu false
  
  breadcrumb do
    # Custom breadcrumb links
    [
      link_to('Springshare', :springshare_root),
      link_to('LibChat', :springshare_libchat)
    ]
  end

  actions :all, :except => [:new, :edit, :update, :destroy]

  preserve_default_filters!
  Springshare::Libchat::Chat.superadmin_columns.each do |c|
    remove_filter c.to_sym
  end
  remove_filter :inquiry_map

  # Set the title on the index page
  index title: "Chats", download_links: [:csv] do

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

  show title: :chat_id do
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
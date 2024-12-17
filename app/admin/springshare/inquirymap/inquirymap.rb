ActiveAdmin.register Springshare::Inquirymap::Inquirymap,
as: "Inquirymap::Inquirymap",
namespace: :springshare do
  menu false
  
  breadcrumb do
    # Custom breadcrumb links
    [
      link_to('Springshare', :springshare_root),
      link_to('InquiryMap', :springshare_inquirymap)
    ]
  end

  actions :all, :except => [:new, :edit, :update, :destroy]

  preserve_default_filters!
  Springshare::Inquirymap::Inquirymap.superadmin_columns.each do |c|
    remove_filter c.to_sym
  end
  remove_filter :chat

  # Set the title on the index page
  index title: "InquiryMap", download_links: [:csv] do

    id_column
    # Maintain link to LibChat even though we are hiding some columns.
    column :chat_id do |inquirymap|
      link_to inquirymap.chat.display_name, springshare_libchat_chat_path(inquirymap.chat_id)
    end
    # Loop through the columns and hide it if not super admin
    self.resource_class.column_names.each do |c|
      next if ["id", "chat_id"].include?(c)
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

      row :id
      # Special case to maintain link between chat id and LibChat
      row :chat_id do |inquirymap|
        link_to inquirymap.chat.display_name, springshare_libchat_chat_path(inquirymap.chat_id)
      end

      # Loop through the columns and hide it if not super admin
      self.resource_class.column_names.each do |c|
        next if ["id", "chat_id"].include?(c)
        next if (
          self.resource_class.superadmin_columns.include?(c) && 
          !current_admin_user.super_admin?
        )

        row c.to_sym
      end
    end
  end  

  csv do
    id_column
    # Specify the Springshare Chat Id
    column :chat_id do |inquirymap|
      inquirymap.chat.display_name
    end
    # Loop through the columns and hide it if not super admin
    self.resource_class.column_names.each do |c|
      next if ["id", "chat_id"].include?(c)
      next if (
        self.resource_class.superadmin_columns.include?(c) &&
        !current_admin_user.super_admin?
      )
      column c.to_sym
    end
    
  end

end
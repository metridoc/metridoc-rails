ActiveAdmin.register Springshare::Libwizard::Etlm,
as: "Libwizard::ETLM Consultations",
namespace: :springshare do
  menu false
  
  breadcrumb do
    # Custom breadcrumb links
    [
      link_to('Springshare', :springshare_root),
      link_to('LibWizard', :springshare_libwizard)
    ]
  end

  actions :all, :except => [:new, :edit, :update, :destroy]

  preserve_default_filters!
  Springshare::Libwizard::Etlm.superadmin_columns.each do |c|
    remove_filter c.to_sym
  end

  # Set the title on the index page
  index title: "ETLM Consulation and Instruction", download_links: [:csv] do
    
    id_column
    # Loop through the columns and hide it if not super admin
    self.resource_class.column_names.each do |c|
      next if c == "id"
      next if (
      self.resource_class.superadmin_columns.include?(c) && 
      !current_admin_user.super_admin?
      )
      
      if ["notes", "patron_question", "session_description", "career_advancement"].include? c
        column c.to_sym do |pr|
          pr[c].truncate 50 unless pr[c].nil?
        end
      else
        column c.to_sym
      end
    end
  end

  show title: :response_id do
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
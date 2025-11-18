module TableRetrieval
  def self.attributes(table_names)
    table_array = table_names.split(",")
    table_attributes = specific_table_attributes_map(table_array)
    {table_attributes: table_attributes}
  end

  def self.all_tables
    all_table_attributes_map.keys.map(&:to_s)
  end

  # Allow all tables for super admins
  # Allow no tables for people without a role
  # Allow certain tables for other users
  def self.allowed_tables(user)
    if user.super_admin?
      return self.all_tables
    elsif user.user_role.blank?
      return []
    end
    
    allowed_sections = user.user_role.user_role_sections.map(&:section)
    all_models = ActiveRecord::Base.descendants.map{
        |model| [
          model.table_name, 
          Security::UserRole.translate_subject_to_section(model)
        ]
      }.to_h
    all_models.select{
        |k,v| allowed_sections.include?(v)
      }.keys()
  end

  private
  def self.all_table_attributes_map
    Rails.cache.fetch("all_table_attributes_map", expires_in: 24.hours) do
      all_tables = ActiveRecord::Base.connection.tables.sort
      retrieve_attributes(all_tables)
    end
  end

  def self.retrieve_attributes(table_array)
    data = {}
    table_array.each do |table_name|
      attributes = ActiveRecord::Base.connection.columns(table_name).map(&:name)
      data[table_name.to_sym] = attributes
    end
    data
  end

  def self.specific_table_attributes_map(table_names)
    sym_table_names = table_names.map(&:to_sym)
    all_table_attributes_map.slice(*sym_table_names)
  end
end

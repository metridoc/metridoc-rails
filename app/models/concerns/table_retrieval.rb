module TableRetrieval
  def self.attributes(table_names)
    table_array = table_names.split(",")
    table_attributes = specific_table_attributes_map(table_array)
    {table_attributes: table_attributes}
  end

  def self.all_tables
    all_table_attributes_map.keys.map(&:to_s)
  end

  private
  def self.all_table_attributes_map
    Rails.cache.fetch("all_table_attributes_map", expires_in: 24.hours) do
      all_tables = ActiveRecord::Base.connection.tables
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

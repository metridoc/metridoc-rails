class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  # `ransackable_associations` by default returns the names
  # of all associations as an array of strings.
  # For overriding with a whitelist array of strings.
  def self.ransackable_associations(auth_object = nil)
    reflect_on_all_associations.map { |a| a.name.to_s }
  end

  # `ransackable_attributes` by default returns all column names
  # and any defined ransackers as an array of strings.
  # For overriding with a whitelist array of strings.
  def self.ransackable_attributes(auth_object = nil)
    self.attribute_names
  end

  def to_xml(options = {})
    xml = options[:builder] ||= ::Builder::XmlMarkup.new(indent: options[:indent])
    xml.tag!(options[:root]) do
      self.attributes.each do |attr_name, attr_value|
        xml.tag!(attr_name.to_sym, attr_value)
        xml.tag!(:institution_name, Institution.find(attr_value).name) if attr_name == 'institution_id'
      end
    end
  end

  # ransack 4+ requires explicit whitelisting for associations and attributes.
  def self.ransackable_associations(auth_object = nil)
    @ransackable_associations ||= reflect_on_all_associations.map { |a| a.name.to_s }
  end

  def self.ransackable_attributes(auth_object = nil)
    @ransackable_attributes ||= column_names + _ransackers.keys + _ransack_aliases.keys + attribute_aliases.keys
  end

end

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

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

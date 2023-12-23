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
end

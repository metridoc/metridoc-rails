module Util
  class << self

    def valid_integer?(v)
      return v.blank? || v.match(/\A[+-]?\d+\z/).present?
    end

    def valid_datetime?(v)
      return true if v.blank?
      return true if Chronic.parse(v).present?
      return DateTime.parse(v).present?
      rescue ArgumentError
        return false
    end

    def parse_datetime(v)
      d = Chronic.parse(v)
      return d if d.present?
      return DateTime.parse(v)
    rescue
      return nil
    end

    def column_to_attribute(column)
      column.underscore.gsub(/[^\dA-Za-z]+/, ' ').strip.gsub(/[\s\_]+/, '_').downcase
    end

  end
end
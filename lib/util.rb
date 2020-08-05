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

    def convert_to_utf8(file_path)
      file_name = File.basename(file_path, File.extname(file_path))
      temp_file = Tempfile.new(file_name)
      `iconv -f iso-8859-1 -t utf-8 #{file_path} > #{temp_file.path}`
      FileUtils.mv(temp_file.path, file_path)
    ensure
      temp_file.close
    end

    def column_to_attribute(column)
      column.underscore.gsub(/[^\dA-Za-z]+/, ' ').strip.gsub(/[\s\_]+/, '_').downcase
    end

  end
end

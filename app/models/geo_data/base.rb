class GeoData::Base < ApplicationRecord
  self.abstract_class = true
  self.table_name_prefix = 'geo_data_'
end

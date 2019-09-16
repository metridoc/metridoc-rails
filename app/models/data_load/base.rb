class DataLoad::Base < ApplicationRecord
  self.abstract_class = true
  self.table_name_prefix = 'data_loads_'
end

class Ipeds::Base < ApplicationRecord
  self.abstract_class = true
  self.table_name_prefix = 'ipeds_'
end

class MeeScan::Base < ApplicationRecord
  self.abstract_class = true
  self.table_name_prefix = 'meescan_'
end

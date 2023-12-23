class Bookkeeping::Base < ApplicationRecord
  self.abstract_class = true
  self.table_name_prefix = 'bookkeeping_'
end

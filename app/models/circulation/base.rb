class Circulation::Base < ApplicationRecord
  self.abstract_class = true
  self.table_name_prefix = 'circulation_'
end
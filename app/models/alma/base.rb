class Alma::Base < ApplicationRecord
  self.abstract_class = true
  self.table_name_prefix = 'alma_'
end
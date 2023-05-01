class Upenn::Base < ApplicationRecord
  self.abstract_class = true
  self.table_name_prefix = 'upenn_'
end

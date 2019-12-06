class Sceti::Base < ApplicationRecord
    self.abstract_class = true
    self.table_name_prefix = 'sceti_'
end

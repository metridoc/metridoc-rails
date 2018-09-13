class Ezborrow::Base < ApplicationRecord
  self.abstract_class = true
  self.table_name_prefix = 'ezb_'
end

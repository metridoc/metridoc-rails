class Consultation::Base < ApplicationRecord
  self.abstract_class = true
  self.table_name_prefix = 'consultation_'
end

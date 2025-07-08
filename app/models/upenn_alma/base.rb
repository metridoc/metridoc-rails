class UpennAlma::Base < ApplicationRecord
  self.abstract_class = true
  self.table_name_prefix = 'upenn_alma_'
end

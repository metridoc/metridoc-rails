class Illiad::Base < ApplicationRecord
  belongs_to :institution

  self.abstract_class = true
  self.table_name_prefix = 'illiad_'

end

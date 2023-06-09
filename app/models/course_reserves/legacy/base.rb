class CourseReserves::Legacy::Base < ApplicationRecord
  self.abstract_class = true
  self.table_name_prefix = 'cr_legacy_'
end

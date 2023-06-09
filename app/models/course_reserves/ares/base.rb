class CourseReserves::Ares::Base < ApplicationRecord
  self.abstract_class = true
  self.table_name_prefix = 'cr_ares_'
end

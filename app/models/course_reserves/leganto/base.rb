class CourseReserves::Leganto::Base < ApplicationRecord
  self.abstract_class = true
  self.table_name_prefix = 'cr_leganto_'
end

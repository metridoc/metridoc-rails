class LibraryStaff::Base < ApplicationRecord
  self.abstract_class = true
  self.table_name_prefix = 'library_staff_'
end

class Springshare::Libcal::Base < ApplicationRecord
  self.abstract_class = true
  self.table_name_prefix = 'ss_libcal_'
end

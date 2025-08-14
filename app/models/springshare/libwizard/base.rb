class Springshare::Libwizard::Base < ApplicationRecord
  self.abstract_class = true
  self.table_name_prefix = 'ss_libwizard_'
end

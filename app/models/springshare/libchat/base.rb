class Springshare::Libchat::Base < ApplicationRecord
  self.abstract_class = true
  self.table_name_prefix = 'ss_libchat_'
end

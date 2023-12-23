module Springshare::Base < ApplicationRecord
  self.abstract_class = true
  self.table_name_prefix = 'ss_'
end

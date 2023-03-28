class Ezproxy::Base < ApplicationRecord
  self.abstract_class = true
  self.table_name_prefix = 'upenn_ezproxy_'
end

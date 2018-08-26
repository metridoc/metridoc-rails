class Keyserver::Base < ApplicationRecord
  self.abstract_class = true
  self.table_name_prefix = 'keyserver_'
end

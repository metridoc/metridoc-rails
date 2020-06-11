module Ares
  class Base < ActiveRecord::Base
    self.abstract_class = true
    self.table_name_prefix = 'ares_'
  end
end

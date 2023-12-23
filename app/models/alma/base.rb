module Alma
  class Base < ActiveRecord::Base
    self.abstract_class = true
    self.table_name_prefix = 'alma_'
  end
end

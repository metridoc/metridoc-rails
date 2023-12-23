module Bookkeeping
  class Base < ActiveRecord::Base
    self.abstract_class = true
    self.table_name_prefix = 'bookkeeping_'
  end
end

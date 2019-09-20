module Bookkeeping
  class DataLoad < ActiveRecord::Base
    self.table_name_prefix = 'bookkeeping_'
  end
end

module Springshare
  class Base < ActiveRecord::Base
    self.abstract_class = true
    self.table_name_prefix = 'ss_'
  end
end

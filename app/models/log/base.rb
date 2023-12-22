class Log::Base < ApplicationRecord
  self.abstract_class = true
  self.table_name_prefix = 'log_'
end

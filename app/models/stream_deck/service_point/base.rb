class StreamDeck::ServicePoint::Base < ApplicationRecord
  self.abstract_class = true
  self.table_name_prefix = 'sd_sp_'
end

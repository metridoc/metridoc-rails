class Ezborrow::Reshare::Base < ApplicationRecord
  self.abstract_class = true
  self.table_name_prefix = 'reshare_'
end

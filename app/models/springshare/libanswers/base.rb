class Springshare::Libanswers::Base < ApplicationRecord
  self.abstract_class = true
  self.table_name_prefix = 'ss_libanswers_'
end

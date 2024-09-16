class GoogleAnalytics::UniversalAnalytics::Base < ApplicationRecord
  self.abstract_class = true
  self.table_name_prefix = 'ga_ua_'
end

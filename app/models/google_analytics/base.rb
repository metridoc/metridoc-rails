class GoogleAnalytics::Base < ApplicationRecord
  self.abstract_class = true
  self.table_name_prefix = 'google_analytics_'
end
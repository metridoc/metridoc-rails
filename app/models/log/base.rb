class Log::Base < ApplicationRecord
  self.abstract_class = true
  self.table_name_prefix = 'log_'

  # Keys that must never be persisted (or written to the SQL log) in the
  # job configuration snapshots. Combines the app-wide filter_parameters
  # (passw, secret, token, _key, ...) with job-config specific patterns.
  SECRET_KEY_PATTERNS = [/password/i, /auth/i, /apikey/i, /api_key/i].freeze

  private

  def filter_secrets(config)
    return config if config.blank?

    ActiveSupport::ParameterFilter.new(
      Rails.application.config.filter_parameters + SECRET_KEY_PATTERNS,
      mask: "[FILTERED]"
    ).filter(config)
  end
end

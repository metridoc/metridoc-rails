require Rails.root.join('config/environments/production')

Rails.application.configure do
  config.i18n.fallbacks = true

  config.active_support.deprecation = :notify
end

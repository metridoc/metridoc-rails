require Rails.root.join('config/environments/production')

Rails.application.configure do
  config.i18n.fallbacks = true

  config.active_support.deprecation = :notify

  # Disable image processing in the browser.
  config.active_storage.variant_processor = :disabled

end

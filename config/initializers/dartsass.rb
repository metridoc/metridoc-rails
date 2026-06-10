# File for DartSass Build Options

# Explicitly add node modules to the dart sass build path
# This is needed to pick up the active_material JavaScript package
Rails.application.config.dartsass.build_options << " --load-path=node_modules"

Rails.application.config.dartsass.builds = {
  'active_admin.scss' => 'active_admin.css',
  'metridoc.scss' => 'metridoc.css',
  'application.scss' => 'application.css'
}

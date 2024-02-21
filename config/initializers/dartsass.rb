# File for DartSass Build Options

# Explicitly add node modules to the dart sass build path
# This is needed to pick up the active_material JavaScript package
Rails.application.config.dartsass.build_options << " --load-path=node_modules"

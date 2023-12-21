source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
# Ruby on Rails is a full-stack web framework optimized for programmer happiness
# and sustainable productivity. It encourages beautiful code by favoring
# convention over configuration.
gem 'rails', '~> 6.1'

# Use sqlite3 as the database for Active Record
# Ruby library to interface with the SQLite3 database engine
# (http://www.sqlite.org). Precompiled binaries are available for common
# platforms for recent versions of Ruby.
gem 'sqlite3'

# Use Puma as the app server
# Puma is a simple, fast, threaded, and highly parallel HTTP 1.1 server
# for Ruby/Rack applications.
gem 'puma', '~> 5.6'

# Rollback mail gem
# Mail > 2.8.0 requires net-protocol which conflicts with standard library
gem 'mail', '= 2.7.1'

# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# This gem combines the speed of libsass, the Sass C implementation,
# with the ease of use of the original Ruby Sass library.
# DEPRECATED, BUT DEPENDENCY EXISTS
gem "sassc"

gem 'pg'
gem 'mysql2'

gem 'makara', '~> 0.4.1'

gem 'activerecord-import'
gem 'active_storage_validations'

gem 'devise'
gem 'activeadmin'
gem 'haml'

#gem 'active_material', github: 'vigetlabs/active_material'
gem 'active_admin_sidebar'

gem 'chartkick'
gem 'active_median'
gem 'groupdate'

# Gem to use d3.js for visualizations
gem 'd3-rails'

# Gem for reading xlsx and csv files
gem 'roo'

# Gem for OAuth2 operations
gem 'oauth2', '~> 2.0'

gem 'chronic'

gem 'delayed_job_active_record'
gem 'daemons'

gem 'dotenv-rails'

gem 'net-sftp'

gem 'terser'

group :development, :test do
  gem 'rb-readline'
  gem 'pry'
  gem 'pry-rails'
  gem 'pry-byebug'
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '~> 2.13.0'
  gem 'selenium-webdriver'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 4.2.0'
  gem 'listen', '>= 3.0.5', '< 3.4'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

  #tiny_tds and activerecord-sqlserver-adapter gems are needed by only import_helper.rb, which is not really part of the app, it is more for diagnosing/troubleshooting sql server sources
  gem 'tiny_tds', '~> 2.1.0'
  gem 'activerecord-sqlserver-adapter', '~> 6.1'
  gem 'rails_db'
  gem "letter_opener"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
# Some versions of Ubuntu also requires this gem
gem 'tzinfo-data'

gem 'todo_runner', :git => 'https://github.com/upenn-libraries/todo_runner.git', :tag => 'v0.4.2'

gem "dartsass-rails", "~> 0.5.0"

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.5'
# Use sqlite3 as the database for Active Record
gem 'sqlite3'
# Use Puma as the app server
gem 'puma', '~> 4.3'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'

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

gem 'pg'
gem 'mysql2'

gem 'makara', '~> 0.4.1'

gem 'activerecord-import'
gem 'active_storage_validations'

gem 'devise'
gem 'activeadmin'
gem 'haml'

gem 'active_material', github: 'vigetlabs/active_material'
gem 'active_admin_sidebar'

gem 'chartkick'
gem 'active_median'
gem 'groupdate'

# Gem to use d3.js for visualizations
gem 'd3-rails'

# Gem for reading xlsx and csv files
gem 'roo'

gem 'chronic'

gem 'delayed_job_active_record'
gem 'daemons'

gem 'dotenv-rails'

gem 'net-sftp'

gem 'terser'

gem 'jquery-rails'

gem 'sprocket-rails'

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
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.4'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

  #tiny_tds and activerecord-sqlserver-adapter gems are needed by only import_helper.rb, which is not really part of the app, it is more for diagnosing/troubleshooting sql server sources
  gem 'tiny_tds', '~> 2.1.0'
  gem 'activerecord-sqlserver-adapter', '~> 5.2.0'
  gem 'rails_db'
  gem "letter_opener"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
# Some versions of Ubuntu also requires this gem
gem 'tzinfo-data'

gem 'todo_runner', :git => 'https://github.com/upenn-libraries/todo_runner.git', :tag => 'v0.4.2'

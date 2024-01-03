source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
# Ruby on Rails is a full-stack web framework optimized for programmer happiness
# and sustainable productivity. It encourages beautiful code by favoring
# convention over configuration.
gem 'rails', '~> 6.1'

###########
# Databases
###########

# Use sqlite3 as the database for Active Record
# Ruby library to interface with the SQLite3 database engine
# (http://www.sqlite.org). Precompiled binaries are available for common
# platforms for recent versions of Ruby.
gem 'sqlite3'

# Pg is the Ruby interface to the PostgreSQL RDBMS.
# It works with PostgreSQL 9.3 and later.
gem 'pg'

# A simple, fast Mysql library for Ruby, binding to libmysql
gem 'mysql2'


#############
# Puma Server
#############

# Use Puma as the app server
# Puma is a simple, fast, threaded, and highly parallel HTTP 1.1 server
# for Ruby/Rack applications.
gem 'puma', '~> 5.6'


###########
# Mail
###########

# A really Ruby Mail handler.
gem 'mail'

# HTTP client api for Ruby.
# Required by mail to handle net-protocol errors
gem 'net-http'

###########
# Display
###########

# Rails engine for Turbolinks 5 support
# Last updated 2019
# Turbolinks makes navigating your web application faster.
# Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'

# Create JSON structures via a Builder-style DSL
# Last updated 2021
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'

# Integrate Dart Sass with the asset pipeline in Rails.
gem "dartsass-rails", "~> 0.5.0"

# This gem combines the speed of libsass, the Sass C implementation,
# with the ease of use of the original Ruby Sass library.
# DEPRECATED, BUT DEPENDENCY EXISTS IN ACTIVE ADMIN
gem "sassc"

# An elegant, structured (X)HTML/XML templating engine.
gem 'haml'

##############
# ActiveRecord
##############

# Makara is generic primary/replica proxy. It handles the heavy lifting of
# managing, choosing, blacklisting, and cycling through connections. It comes
# with an ActiveRecord database adapter implementation.
# Last updated 2021
gem 'makara', '~> 0.4.1'

# A library for bulk inserting data using ActiveRecord.
gem 'activerecord-import'

# Validations for Active Storage (presence)
gem 'active_storage_validations'

# ActiveRecord backend for Delayed::Job
gem 'delayed_job_active_record'

##############
# ActiveAdmin
##############

# Flexible authentication solution for Rails with Warden
# Dependency of ActiveAdmin
gem 'devise'

# The administration framework for Ruby on Rails.
gem 'activeadmin'

# Extension for activeadmin gem to manage sidebar
# Last updated 2020
gem 'active_admin_sidebar'

###################
# Dashboard Helpers
###################

# Create beautiful JavaScript charts with one line of Ruby
gem 'chartkick'

# Median and percentile for Active Record, Mongoid, arrays, and hashes
gem 'active_median'

# The simplest way to group temporal data
gem 'groupdate'

# Gem to use d3.js for visualizations
# This gem provides D3 for Rails Asset Pipeline.
gem 'd3-rails'

###########
# Utilities
###########

# Gem for reading xlsx and csv files
# Roo can access the contents of various spreadsheet files.
# It can handle * OpenOffice * Excelx * LibreOffice * CSV
gem 'roo'

# Gem for OAuth2 operations
# A Ruby wrapper for the OAuth 2.0 protocol built with a similar style to the
# original OAuth spec.
# Last updated 2021
gem 'oauth2', '~> 2.0'

# Chronic is a natural language date/time parser written in pure Ruby.
# Last updated 2013
gem 'chronic'

# Daemons provides an easy way to wrap existing ruby scripts (for example a
# self-written server) to be run as a daemon and to be controlled by simple
# start/stop/restart commands
# Last updated 2021
gem 'daemons'

# Autoload dotenv in Rails.
# Last updated 2022
gem 'dotenv-rails'

# A pure Ruby implementation of the SFTP client protocol
# Last updated 2022
gem 'net-sftp'

# Terser minifies JavaScript files by wrapping TerserJS to be accessible in Ruby
gem 'terser'

group :development, :test do
  # The readline library provides a pure Ruby implementation of the GNU
  # readline C library, as well as the Readline extension that ships as
  # part of the standard library.
  # Last updated 2017
  gem 'rb-readline'

  # Pry is a runtime developer console and IRB alternative with powerful
  # introspection capabilities.
  # Last updated 2013
  gem 'pry'

  # Use Pry as your rails console
  # Last updated 2018
  gem 'pry-rails'

  # Combine 'pry' with 'byebug'. Adds 'step', 'next', 'finish', 'continue'
  # and 'break' commands to control execution.
  # Last updated 2022
  gem 'pry-byebug'

  # Call 'byebug' anywhere in the code to stop execution and get a debugger
  # console
  # Byebug is a Ruby debugger. It's implemented using the TracePoint C API for
  # execution control and the Debug Inspector C API for call stack navigation
  # Last updated 2020
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]

  # Adds support for Capybara system testing and selenium driver
  # Capybara is an integration testing tool for rack based web applications.
  # It simulates how a user would interact with a website
  gem 'capybara', '~> 2.13.0'

  # Selenium implements the W3C WebDriver protocol to automate popular browsers.
  # It aims to mimic the behaviour of a real user as it interacts with the
  # application's HTML. It's primarily intended for web application testing,
  # but any web-based task can automated.
  gem 'selenium-webdriver'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %>
  # anywhere in the code.
  # A debugging tool for your Ruby on Rails applications.
  gem 'web-console', '>= 4.2.0'

  # The Listen gem listens to file modifications and notifies you about the
  # changes. Works everywhere!
  gem 'listen', '>= 3.0.5', '< 3.4'

  # Spring speeds up development by keeping your application running in the
  # background. Read more: https://github.com/rails/spring
  # Preloads your application so things like console, rake and tests run faster
  gem 'spring'

  # Makes spring watch files using the listen gem.
  # Last updated in 2022
  gem 'spring-watcher-listen', '~> 2.0.0'

  #tiny_tds and activerecord-sqlserver-adapter gems are needed by only
  # import_helper.rb, which is not really part of the app, it is more for
  # diagnosing/troubleshooting sql server sources

  # TinyTDS - A modern, simple and fast FreeTDS library for Ruby using DB-Library.
  # Developed for the ActiveRecord SQL Server adapter.
  gem 'tiny_tds', '~> 2.1.0'

  # ActiveRecord SQL Server Adapter. SQL Server 2012 and upward.
  gem 'activerecord-sqlserver-adapter', '~> 6.1'

  # Quick way to inspect your Rails database, see content of tables, filter,
  # export them to CSV, Excel, EXPLAIN SQL and run SQL queries.
  gem 'rails_db'

  # When mail is sent from your application, Letter Opener will open a preview
  # in the browser instead of sending.
  # Last updated 2022
  gem "letter_opener"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
# Some versions of Ubuntu also requires this gem
gem 'tzinfo-data'

gem 'todo_runner', :git => 'https://github.com/upenn-libraries/todo_runner.git', :tag => 'v0.4.2'

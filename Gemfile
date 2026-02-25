source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
# Ruby on Rails is a full-stack web framework optimized for programmer happiness
# and sustainable productivity. It encourages beautiful code by favoring
# convention over configuration.
gem 'rails', '>= 7.2'

###########
# Databases
###########

# Use sqlite3 as the database for Active Record
# Ruby library to interface with the SQLite3 database engine
# (http://www.sqlite.org). Precompiled binaries are available for common
# platforms for recent versions of Ruby.
# Needed to avoid errors on build?
gem 'sqlite3'


# Pg is the Ruby interface to the PostgreSQL RDBMS.
# It works with PostgreSQL 9.3 and later.
gem 'pg'

# A simple, fast Mysql library for Ruby, binding to libmysql
gem 'mysql2'

# The SQL Server adapter for ActiveRecord using SQL Server 2012 or higher.
# Needed for connections to ILLIAD databases
# Versioning paired with Rails
gem 'activerecord-sqlserver-adapter', '~> 7.2'

# The Scenic Gem provides easy ways to create PostgreSQL views to interact
# with rails infrastructure.
gem 'scenic'

#############
# Puma Server
#############

# Use Puma as the app server
# Puma is a simple, fast, threaded, and highly parallel HTTP 1.1 server
# for Ruby/Rack applications.
gem 'puma', '~> 7'

###########
# Mail
###########

# A really Ruby Mail handler.
gem 'mail'

###########
# Display
###########

# Turbo gives you the speed of a single-page web application without having to
# write any JavaScript.
gem "turbo-rails"

# Create JSON structures via a Builder-style DSL
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'

# Integrate Dart Sass with the asset pipeline in Rails.
gem "dartsass-rails"


gem "sprockets-rails"
# This gem combines the speed of libsass, the Sass C implementation,
# with the ease of use of the original Ruby Sass library.
# DEPRECATED, BUT DEPENDENCY EXISTS IN SPROCKETS
gem "sassc"

# An elegant, structured (X)HTML/XML templating engine.
gem 'haml'

##############
# ActiveRecord
##############

# A library for bulk inserting data using ActiveRecord.
gem 'activerecord-import'

# Validations for Active Storage (attachments)
gem 'active_storage_validations'

# ActiveRecord backend for Delayed::Job
gem 'delayed_job_active_record'

##############
# ActiveAdmin
##############

# Flexible authentication solution for Rails with Warden
# Dependency of ActiveAdmin
gem 'devise', '~> 4.9', '>= 4.9.4'

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
gem 'oauth2', '~> 2.0'

# Chronic is a natural language date/time parser written in pure Ruby.
# Last updated 2013
gem 'chronic'

# Autoload dotenv in Rails.
gem 'dotenv'

# A pure Ruby implementation of the SFTP client protocol
# Only used in lib/export/sftp/task.rb
# Last updated 2022, unmaintained
gem 'net-sftp'

# Gem used to connect to AWS
gem 'aws-sdk-dynamodb'

group :development, :test do

  # This library provides debugging functionality to Ruby (MRI) 2.7 and later.
  # This debug.rb is the replacement of traditional lib/debug.rb standard library.
  # Replaced byebug with this utility.
  gem "debug", ">= 1.0.0"

  # Selenium implements the W3C WebDriver protocol to automate popular browsers.
  # It aims to mimic the behaviour of a real user as it interacts with the
  # application's HTML. It's primarily intended for web application testing,
  # but any web-based task can automated.
  gem 'selenium-webdriver'

  # Minitest 6+ is only compatible with railties 8.0.4+
  # Have to cap minitest for rails 7 compatibility
  gem 'minitest', '~> 5.27'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %>
  # anywhere in the code.
  # A debugging tool for your Ruby on Rails applications.
  gem 'web-console', '>= 4.2.0'

  # The Listen gem listens to file modifications and notifies you about the
  # changes. Works everywhere!
  gem 'listen', '>= 3.0.5', '< 4.0'

  # Spring speeds up development by keeping your application running in the
  # background. Read more: https://github.com/rails/spring
  # Preloads your application so things like console, rake and tests run faster
  gem 'spring'

  # Makes spring watch files using the listen gem.
  # Last updated in 2022
  gem 'spring-watcher-listen', '~> 2.1.0'

  #tiny_tds and activerecord-sqlserver-adapter gems are needed by only
  # import_helper.rb, which is not really part of the app, it is more for
  # diagnosing/troubleshooting sql server sources

  # TinyTDS - A modern, simple and fast FreeTDS library for Ruby using DB-Library.
  # Developed for the ActiveRecord SQL Server adapter.
  gem 'tiny_tds'

  # ActiveRecord SQL Server Adapter. SQL Server 2012 and upward.

  # Quick way to inspect your Rails database, see content of tables, filter,
  # export them to CSV, Excel, EXPLAIN SQL and run SQL queries.
  gem 'rails_db'

end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
# Some versions of Ubuntu also requires this gem
gem 'tzinfo-data'

##############
# Natural Language Processing
##############

# VADER (Valence Aware Dictionary and sEntiment Reasoner) is a lexicon and 
# rule-based sentiment analysis tool that is specifically attuned to sentiments 
# expressed in social media.
gem 'vader_sentiment_ruby'

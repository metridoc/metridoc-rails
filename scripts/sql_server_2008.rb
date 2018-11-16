# require 'rubygems'
ENV['BUNDLE_GEMFILE'] = 'Gemfile.sqlserver2008'
require 'bundler/setup'
Bundler.require(:default)

# require 'active_record'
require '../lib/import_helper/mssql.rb'
require '../lib/import_helper/mssql/task.rb'


m = Mssql::Mssql.new("upenn_illiad", "/tmp/")
puts m.execute(1)
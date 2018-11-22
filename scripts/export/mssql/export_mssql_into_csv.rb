# require 'rubygems'
ENV['BUNDLE_GEMFILE'] = 'Gemfile.sqlserver2008'
require 'bundler/setup'
Bundler.require(:default)

# require 'active_record'
require './main.rb'
require './task.rb'

m = Export::Mssql::Main.new("upenn_illiad")
puts m.execute([], true)
# require 'rubygems'
ENV['BUNDLE_GEMFILE'] = 'Gemfile.sqlserver'
require 'bundler/setup'
Bundler.require(:default)

# require 'active_record'
require './main.rb'
require './task.rb'

folder = ARGV[0]
test_mode = ARGV.size > 1 && ARGV[1] == "test"

puts "Started running Export::Mssql for #{folder} #{test_mode ? " - Test Mode" : ""}"
m = Export::Mssql::Main.new(folder, test_mode)
m.execute
puts "Ended running Export::Mssql for #{folder} #{test_mode ? "= Test Mode" : ""}"

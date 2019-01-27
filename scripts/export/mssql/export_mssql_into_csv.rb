# require 'rubygems'
ENV['BUNDLE_GEMFILE'] = 'Gemfile.sqlserver'
require 'bundler/setup'
require 'optparse'
Bundler.require(:default)

# require 'active_record'
require './main.rb'
require './task.rb'

parameters = [
  ["c", "config_folder", "Required Configuration Folder"],
  ["t", "test_mode", "Optional Test mode true/false"],
  ["s", "single_step", "Optional Single Step to run"],
  ["e", "export_folder", "Optional Export Folder"],
]

options = {}

option_parser = OptionParser.new
option_parser.banner = "Usage: rake import -- --options"
parameters.each do |short, long, description|
  option_parser.on("-#{short} value", "--#{long} value", description) { |parameter_value|
    options[long.to_sym] = parameter_value
  }
end
# return `ARGV` with the intended arguments
args = option_parser.order!(ARGV) {}
option_parser.parse!(args)

puts "Started running Export::Mssql"
m = Export::Mssql::Main.new(options)
exit m.execute(options[:single_step].present? ? [options[:single_step]] : nil) ? 0 : 1

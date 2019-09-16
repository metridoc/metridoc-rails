# require 'rubygems'
ENV['BUNDLE_GEMFILE'] = 'Gemfile.sqlserver'
require 'bundler/setup'
require 'optparse'
require 'makara'
Bundler.require(:default)

# hack to get the activerecord 4.1.2 work with Ruby 2.5.1
module Arel
  module Visitors
    class DepthFirst < Arel::Visitors::Visitor
      alias :visit_Integer :terminal
    end

    class Dot < Arel::Visitors::Visitor
      alias :visit_Integer :visit_String
    end

    class ToSql < Arel::Visitors::Visitor
      alias :visit_Integer :literal
    end
  end
end


# require 'active_record'
require './main.rb'
require './task.rb'

parameters = [
  ["c", "config_folder", "Required Configuration Folder"],
  ["t", "test_mode", "Optional Test mode true/false"],
  ["s", "single_step", "Optional Single Step to run"],
  ["e", "export_folder", "Optional Export Folder"],
  ["f", "from_date", "From Date"],
  ["o", "to_date", "To Date"]
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

#! /usr/bin/env ruby

require 'tiny_tds'
require 'pry'

db = TinyTds::Client.new(username: ENV['CORNELL_ILLIAD_MSSQL_UID'], password: ENV['CORNELL_ILLIAD_MSSQL_PWD'], host: ENV['CORNELL_ILLIAD_MSSQL_HOST'], database: ENV['CORNELL_ILLIAD_MSSQL_DB'])

query = %Q{SELECT * FROM Groups}

results = db.execute(query).entries

binding.pry

db.close



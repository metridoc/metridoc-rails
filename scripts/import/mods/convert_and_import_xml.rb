#!/usr/bin/env ruby

require 'pry'

marc_files = ARGV[0]

dest = ARGV[1]

Dir.glob("#{marc_files}/*.xml").each_with_index do |file, index|
  puts "processing #{file}..."
  `xsltproc MARC21slim2MODS3-6.xsl #{file} > #{dest}/books_mods_#{index}.xml`
  puts "#{file} processed."
end

Dir.glob("#{dest}/books_mods*.xml").each_with_index do |file, index|
  puts "loading #{file}..."
  FileUtils.mv(file, '/var/local/books_mods.xml')
  `rake import -c marc_xml`
  puts "#{file} loaded."
end

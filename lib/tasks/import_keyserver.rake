namespace :import do
  namespace :csv do

    desc "Import Keyserver Data"
    task :keyserver, %i[source_dir] => :environment do |_t, args|
      source_dir = args.source_dir
      puts "Importing Keyserver data from #{source_dir}"
      raise "Directory not found!" unless File.exists?(source_dir)
      
      filenames = Dir.new(source_dir).reject{|f| /^\.\.?$/.match(f)}
      filenames.each do |filename|
        # TODO import the data from each CSV
      end
    end

    desc "Generate migration code that can be pasted into a migration"
    task :generate_migration_params, %i[source_dir] => :environment do |_t, args|
      source_dir = args.source_dir

      filenames = Dir.new(source_dir).reject{|f| /^\.\.?$/.match(f)}
      puts "class CreateKeyserverTables < ActiveRecord::Migration[#{Rails.version.gsub(/\.\d$/, '')}]"
      puts "  def change"
      filenames.each do |filename|
        table_name = filename.gsub(/\.csv$/, '').underscore
        column_names, sample_row = File.open("#{source_dir}/#{filename}"){|f| [f.readline, f.readline]}
        [column_names, sample_row].map!{|row| row.split(',').map(&:chomp) }
        # [column_names, sample_row].map!{|row| row.split(',').map(&:chomp) }

        puts column_names.inspect
        puts sample_row.inspect

        format_migration_data(table_name, column_names, sample_row)
      end
      puts "  end"
      puts "end"
    end
  end
end

def format_migration_data(table_name, column_names, sample_row=[])
  transformed_column_names = column_names.map{|cn| transform_column_name(cn)}
  inferred_column_types = Hash[transformed_column_names.each.map do |column_name|
    [column_name, infer_column_type(column_name)]
  end]

  puts "    create_table :#{table_name} do |t|"
  inferred_column_types.each_with_index do |name,type,index|
    puts "      t.#{type} :#{name}"
    puts "      # sample: #{sample_row.join(',')}"
  end
  # TODO add a json column for any new columns that appear in future CSVs
  # TODO have the importer put any columns missing from the schema into the json
  # TODO placeholder story to notify about schema changes
  puts "    end"
end

def transform_column_name(name)
  name.underscore
end

def infer_column_type(name)
  case name
  when /_id$/, /_size(_|$)/, /_count(_|$)/
    :integer
  when /audit_(first|last)/
    :datetime
  when /(^|_)date(_|$)/
    :date
  when /^audit_computer_id$/
    :string
  else
    :string
  end
end

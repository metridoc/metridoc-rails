namespace :import do
  namespace :csv do

    desc "Convert Keyserver Data"
    task :convert, %i[source_dir] => :environment do |_t, args|
      source_dir = args.source_dir

      file_path = source_dir + "Programs.csv"
      puts "Fixing encoding for #{file_path}"
      sh "iconv -f ISO-8859-1 -t UTF-8 #{file_path} > #{file_path}.new && rm -f #{file_path} && mv #{file_path}.new #{file_path}"

      #Remove No Asset Information to nil in Computers.csv
      file_path = source_dir + "Computers.csv"
      puts "Removing No Asset Information to nil in #{file_path}"
      sh "sed -i '' -e 's/No Asset Information//g' #{file_path}"

    end

    desc "Import Keyserver Data"
    task :keyserver, %i[source_dir] => :environment do |_t, args|
      source_dir = args.source_dir
      log "Importing Keyserver data from #{source_dir}"
      raise "Directory not passed!" if source_dir.blank?
      raise "Directory not found!" unless File.exists?(source_dir)

      require 'csv'

      filenames = Dir.new(source_dir).reject{|f| /^\.\.?$/.match(f)}
      filenames.each do |filename|
        log "Processing #{filename}"

        base_name = File.basename(filename, ".*")

        begin
          class_name = ("Keyserver::" + base_name.singularize).constantize
        rescue
          log "Class not found for #{filename}, bypassing." && next
        end

        csv = CSV.read("#{source_dir}/#{filename}")

        headers = csv.first

        records = []
        n_errors = 0
        csv.drop(1).each_with_index do |row, n|
          if n_errors >= 100
            log "Too may errors #{n_errors}, exiting!"
            records = []
            break
          end
          z = {}
          headers.each_with_index do |k,i| 
            v = row[i]
            #validations
            if class_name.columns_hash[k.underscore].type == :integer && !valid_integer?(v)
              log "Invalid integer #{v} in #{row.join(",")}"
              n_errors = n_errors + 1
              next
            end
            if class_name.columns_hash[k.underscore].type == :datetime && !valid_datetime?(v)
              log "Invalid datetime #{v} in #{row.join(",")}"
              n_errors = n_errors + 1
              next
              v = DateTime.strptime(v,"%Y%m%d%H%M%SZ")
            end
            if class_name.columns_hash[k.underscore].type == :date && !valid_datetime?(v)
              log "Invalid date #{v} in #{row.join(",")}"
              n_errors = n_errors + 1
              next
              v = DateTime.strptime(v,"%Y%m%d%H%M%SZ")
            end

            z[k.underscore.to_sym] = v
          end
          records << class_name.new(z)
          
          if records.size >= 10000
            class_name.import records
            log "Imported #{records.size} records from #{filename}"
            records = []
          end
        end
        if records.size > 0
          class_name.import records
          log "Imported #{records.size} records from #{filename}"
        end
        log "#{n_errors} errors with #{filename}" if n_errors > 0
        log "Finished importing #{filename}"

      end

    end

    desc "Generate migration code that can be pasted into a migration"
    task :generate_migration_params, %i[source_dir] => :environment do |_t, args|
      source_dir = args.source_dir

      require 'csv'

      filenames = Dir.new(source_dir).reject{|f| /^\.\.?$/.match(f)}
      puts "class CreateKeyserverTables < ActiveRecord::Migration[#{Rails.version.gsub(/\.\d$/, '')}]"
      puts "  def change"
      filenames.each do |filename|
        csv = CSV.read("#{source_dir}/#{filename}")

        table_name = filename.gsub(/\.csv$/, '').underscore
        column_names = csv.first
        sample_row = csv.size > 1 ? csv.second : []

        # puts column_names.inspect
        # puts sample_row.inspect

        format_migration_data("keyserver", table_name, column_names, sample_row)
      end
      puts "  end"
      puts "end"
    end
  end
end

def log(m)
  puts "#{Time.now} - #{m}"
end

def format_migration_data(prefix, table_name, column_names, sample_row=[])
  transformed_column_names = column_names.map{|cn| transform_column_name(cn)}
  inferred_column_types = Hash[transformed_column_names.each.map do |column_name|
    [column_name, infer_column_type(column_name)]
  end]

  puts "    create_table :#{prefix}_#{table_name} do |t|"
  inferred_column_types.each do |name,type|
    puts "      t.#{type} :#{name}"
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

def valid_integer?(v)
  return v.blank? || v.match(/\A[+-]?\d+\z/).present?
end

def valid_datetime?(v)
  return v.blank? || v.match(/\A\d{14}[Z]\z/).present?
end


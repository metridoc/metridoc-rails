namespace :import do
  namespace :mysql do

    desc "Generate migration code for borrrowdirect and save into a target file"
    task :generate_borrrowdirect_migration, [:output_file_name] => [:environment]  do |_t, args|
      generate_migration("database_borrrowdirect.yml", args[:output_file_name], 'bd_', 'borrowdirect')
    end

    desc "Generate migration code for ezborrow and save into a target file"
    task :generate_ezborrow_migration, [:output_file_name] => [:environment]  do |_t, args|
      generate_migration("database_ezborrow.yml", args[:output_file_name], 'ezb_', 'ezborrow')
    end

    desc "Copy ezborrow data from mysql into app database"
    task :import_ezborrow_data => [:environment]  do |_t, args|
      import_mysql_data("database_ezborrow.yml", 'ezb_', 'Ezborrow')
    end

    desc "Copy borrowdirect data from mysql into app database"
    task :import_borrowdirect_data => [:environment]  do |_t, args|
      import_mysql_data("database_borrowdirect.yml", 'bd_', 'Borrowdirect')
    end

  end
end

def log(m)
  puts "#{Time.now} - #{m}"
end

def import_mysql_data(db_yml_name, prefix, namespace)

  mysql_db = YAML.load_file(File.join(Rails.root, "config", db_yml_name))[Rails.env.to_s] 

  connection = ActiveRecord::Base.establish_connection(mysql_db).connection

  table_names = []

  require "csv"

  table_results = connection.select_all("SHOW TABLES LIKE '#{prefix}%';")
  table_results.each do |tr|
    table_names << tr.values.first
  end

  connection.close

  table_names.each do |table_name|
    log "Importing mysql table #{table_name}"
    import_mysql_table(db_yml_name, prefix, table_name, namespace)
  end

end


def import_mysql_table(db_yml_name, prefix, table_name, namespace)

  mysql_db = YAML.load_file(File.join(Rails.root, "config", db_yml_name))[Rails.env.to_s] 

  connection = ActiveRecord::Base.establish_connection(mysql_db).connection

  require "csv"

  csv_file_path = "tmp/#{table_name}.csv"

  row_results = connection.select_all("SELECT * FROM #{table_name};")

  CSV.open(csv_file_path, "wb") do |csv|
    if row_results.count > 0
      csv << row_results.first.keys.map { |x| x == 'id' ? generate_id_field_name(table_name) : x }
    end
    row_results.each do |row|
      csv << row.values
    end
  end

  connection.close

  app_db = YAML.load_file(File.join(Rails.root, "config", "database.yml"))[Rails.env.to_s] 
  connection = ActiveRecord::Base.establish_connection(app_db).connection

  class_name = "#{namespace}::#{table_name[prefix.length..-1].singularize.classify}".constantize

  csv = CSV.read(csv_file_path)

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
      z[k.underscore.to_sym] = v
    end
    records << class_name.new(z)

    if records.size >= 10000
      class_name.import records
      log "Imported #{records.size} records from #{table_name}"
      records = []
    end
  end
  if records.size > 0
    class_name.import records
    log "Imported #{records.size} records from #{table_name}"
  end
  log "#{n_errors} errors with #{table_name}" if n_errors > 0
  log "Finished importing #{table_name}"

  connection.close
end

def convert_column_type(t)
  return [:integer, 8] if /bigint\(/.match(t)
  return [:integer, nil] if /int\(/.match(t)
  return [:boolean, nil] if /bit\(1\)/.match(t)
  return [:datetime, nil] if /datetime/.match(t)
  return [:timestamp, nil] if /timestamp/.match(t)
  return [:text, nil] if /longtext/.match(t)
  return [:float, nil] if /double/.match(t)

  m = /varchar\((\d+)\)/.match(t)
  if m.present?
    return [:string, m[1].to_i]
  end

  m = /char\((\d+)\)/.match(t)
  if m.present?
    return [:string, m[1].to_i]
  end

  raise "unable to find type for #{t}"
end


def generate_migration(db_yml_name, output_file_name, prefix, namespace)
  output_file_path = Rails.root.join("db/migrate/#{output_file_name}").to_s

  first_line = File.open(output_file_path) {|f| f.readline}

  output_file = File.open(output_file_path, "w")

  mysql_db = YAML.load_file(File.join(Rails.root, "config", db_yml_name))[Rails.env.to_s] 

  connection = ActiveRecord::Base.establish_connection(mysql_db).connection

  output_file.puts first_line

  output_file.puts "  def change"
  table_results = connection.select_all("SHOW TABLES LIKE '#{prefix}%';")
  table_results.each do |tr|
    table_name = tr.values.first

    column_results = connection.select_all("SHOW COLUMNS FROM #{table_name};")

    output_file.puts "    create_table :#{namespace}_#{table_name[prefix.length..-1].pluralize} do |t|"
    column_results.each do |cr|
      field = cr["Field"]
      type = cr["Type"]
      null = cr["Null"]
      key = cr["Key"]
      default = cr["Default"]
      extra = cr["Extra"]

      # log cr.inspect

      column_type, limit = convert_column_type(type)

      if field == 'id'
        field = generate_id_field_name(table_name)
      end

      column_definition = "      t.#{column_type.to_s} :#{field} "
      column_definition += ", limit: #{limit}" if limit
      column_definition += ", null: false" if null == "NO"

      output_file.puts column_definition
    end
    output_file.puts "    end"
    output_file.puts ""

  end
  output_file.puts "  end"
  output_file.puts "end"

  output_file.close
  log "Successfully finished generating schema into #{output_file_path}"
end

def generate_id_field_name(table_name)
  "#{table_name.tableize.singularize}_id"
end
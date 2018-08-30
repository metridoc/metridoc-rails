namespace :import do
  namespace :mysql do

    desc "Generate migration code for borrrowdirect and save into a target file"
    task :generate_borrrowdirect_migration, [:output_file_path] => [:environment]  do |_t, args|
      generate_migration("database_borrrowdirect.yml", args[:output_file_path], 'bd_')
    end

    desc "Generate migration code for ezborrow and save into a target file"
    task :generate_ezborrow_migration, [:output_file_path] => [:environment]  do |_t, args|
      generate_migration("database_ezborrow.yml", args[:output_file_path], 'ezb_')
    end

    desc "Generate migration code for ILLiad and save into a target file"
    task :generate_illiad_migration, [:output_file_path] => [:environment]  do |_t, args|
      generate_migration("database_illiad.yml", args[:output_file_path], 'ill_')
    end

  end
end

def log(m)
  puts "#{Time.now} - #{m}"
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


def generate_migration(db_yml_name, output_file_path, prefix)
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

    output_file.puts "    create_table :#{table_name.pluralize} do |t|"
    column_results.each do |cr|
      field = cr["Field"]
      type = cr["Type"]
      null = cr["Null"]
      key = cr["Key"]
      default = cr["Default"]
      extra = cr["Extra"]

      # log cr.inspect

      column_type, limit = convert_column_type(type)

      next if (key == "PRI" || (field == 'id' && extra == 'auto_increment') ) && column_type == :integer

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
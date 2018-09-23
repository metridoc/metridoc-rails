namespace :import do
  namespace :sqlserver do

    desc "Generate migration code for ezborrow and save into a target file"
    task :generate_ezborrow_migration, [:output_file_name] => [:environment]  do |_t, args|
      conn_params_hash = {   host:     ENV['EZBORROW_MSSQL_HOST'],
                             port:     ENV['EZBORROW_MSSQL_PORT'],
                             database: ENV['EZBORROW_MSSQL_DB'],
                             username: ENV['EZBORROW_MSSQL_UID'],
                             password: ENV['EZBORROW_MSSQL_PWD']
      } 
      generate_migration(conn_params_hash, args[:output_file_name], '', 'ezborrow')
    end

    desc "Generate sql defintion for ezborrow and save into a target file"
    task :generate_ezborrow_sql_definition, [:output_file_name] => [:environment]  do |_t, args|
      conn_params_hash = {   host:     ENV['EZBORROW_MSSQL_HOST'],
                             port:     ENV['EZBORROW_MSSQL_PORT'],
                             database: ENV['EZBORROW_MSSQL_DB'],
                             username: ENV['EZBORROW_MSSQL_UID'],
                             password: ENV['EZBORROW_MSSQL_PWD']
      } 
      generate_sql_definition(conn_params_hash, args[:output_file_name], '', 'ezborrow')
    end

    desc "Generate sql defintion for borrowdirect and save into a target file"
    task :generate_borrowdirect_sql_definition, [:output_file_name] => [:environment]  do |_t, args|
      conn_params_hash = {   host:     ENV['BORROWDIRECT_MSSQL_HOST'],
                             port:     ENV['BORROWDIRECT_MSSQL_PORT'],
                             database: ENV['BORROWDIRECT_MSSQL_DB'],
                             username: ENV['BORROWDIRECT_MSSQL_UID'],
                             password: ENV['BORROWDIRECT_MSSQL_PWD']
      } 
      generate_sql_definition(conn_params_hash, args[:output_file_name], '', 'ezborrow')
    end

  end
end

def log(m)
  puts "#{Time.now} - #{m}"
end

def convert_column_type(type_name, precision, scale)
  r_column_type = nil
  r_limit = nil
  r_precision = nil
  r_scale = nil

  if /int/.match(type_name)
    r_column_type = :integer
  elsif /nvarchar/.match(type_name)
    r_column_type = :string
    r_limit = precision
  elsif /nchar/.match(type_name)
    r_column_type = :string
    r_limit = precision
  elsif /datetime/.match(type_name)
    r_column_type = :datetime
  elsif /varbinary/.match(type_name)
    r_column_type = :binary
    r_limit = precision
  elsif /decimal/.match(type_name)
    r_column_type = :decimal
    r_precision = precision
    r_scale = scale
  else
    raise "unable to find type for #{type_name}"
  end

  return [r_column_type, r_limit, r_precision, r_scale]
end


def generate_migration(conn_params_hash, output_file_name, prefix, namespace)
  output_file_path = Rails.root.join('tmp', output_file_name).to_s

  output_file = File.open(output_file_path, "w")

  db_conn_hash = {    adapter: "sqlserver",
                      pool: 5,
                      timeout: 5000 }.merge(conn_params_hash)

  connection = ActiveRecord::Base.establish_connection(db_conn_hash).connection

  output_file.puts "  def change"
  table_results = connection.select_all("SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE='BASE TABLE';")
  table_results.each do |tr|
    table_name = tr.values.first.downcase

    column_results = connection.select_all("exec sp_columns #{table_name};")

    output_file.puts "    create_table :#{namespace}_#{table_name[prefix.length..-1].pluralize} do |t|"
    column_results.each do |cr|
      column_name = cr["COLUMN_NAME"].downcase rescue ""
      precision = cr["PRECISION"]
      scale = cr["SCALE"]
      length = cr["LENGTH"]
      type_name = cr["TYPE_NAME"].downcase rescue ""
      is_nullable = cr["IS_NULLABLE"]
      column_def = cr["COLUMN_DEF"].downcase rescue ""

      puts "#{table_name} - #{column_name} - #{type_name} - length:#{length} - precision:#{precision} - scale: #{scale}"

      column_type, limit, precision, scale = convert_column_type(type_name, precision, scale)

      if column_name == 'id'
        column_name = generate_id_field_name(table_name)
      end

      column_definition = "      t.#{column_type.to_s} :#{column_name} "
      column_definition += ", limit: #{limit}" if limit
      column_definition += ", precision: #{precision}" if precision
      column_definition += ", scale: #{scale}" if scale
      column_definition += ", null: false" if is_nullable == "NO"

      output_file.puts column_definition
    end
    output_file.puts "    end"
    output_file.puts ""

  end
  output_file.puts "  end"

  output_file.close
  log "Successfully finished generating schema into #{output_file_path}"
end


def generate_sql_definition(conn_params_hash, output_file_name, prefix, namespace)
  output_file_path = Rails.root.join('tmp', output_file_name).to_s

  output_file = File.open(output_file_path, "w")

  output_file.puts "#{conn_params_hash[:database]}"

  db_conn_hash = {    adapter: "sqlserver",
                      pool: 5,
                      timeout: 5000 }.merge(conn_params_hash)

  connection = ActiveRecord::Base.establish_connection(db_conn_hash).connection

  table_results = connection.select_all("SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE='BASE TABLE';")
  table_results.each do |tr|
    table_name = tr.values.first

    output_file.puts "  #{table_name}"

    column_results = connection.select_all("exec sp_columns #{table_name};")
    column_results.each do |cr|
      column_name = cr["COLUMN_NAME"].downcase rescue ""
      precision = cr["PRECISION"]
      scale = cr["SCALE"]
      length = cr["LENGTH"]
      type_name = cr["TYPE_NAME"].downcase rescue ""
      is_nullable = cr["IS_NULLABLE"]
      column_def = cr["COLUMN_DEF"].downcase rescue ""

      column_definition = "    #{column_name}"
      column_definition += ", #{type_name}" if type_name
      column_definition += ", precision: #{precision}" if precision
      column_definition += ", scale: #{scale}" if scale
      column_definition += ", length: #{length}" if length && !precision
      column_definition += ", null: false" if is_nullable == "NO"

      output_file.puts column_definition
    end
    output_file.puts ""
    output_file.puts ""

  end

  output_file.close
  log "Successfully finished generating schema into #{output_file_path}"
end

def generate_id_field_name(table_name)
  "#{table_name.tableize.singularize}_id"
end

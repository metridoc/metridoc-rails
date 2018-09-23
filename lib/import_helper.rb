module ImportHelper
  class << self

    def generate_mysql_migration(output_file_name, prefix, namespace)
      db_conn_hash = {    host:     ENV["#{namespace.upcase}_MYSQL_HOST"],
                          port:     ENV["#{namespace.upcase}_MYSQL_PORT"],
                          database: ENV["#{namespace.upcase}_MYSQL_DB"],
                          username: ENV["#{namespace.upcase}_MYSQL_UID"],
                          password: ENV["#{namespace.upcase}_MYSQL_PWD"],
                          adapter:  'mysql2',
                          encoding: 'utf8',
                          pool:     5,
                          timeout:  5000 }

      connection = ActiveRecord::Base.establish_connection(db_conn_hash).connection

      output_file_path = Rails.root.join('tmp', output_file_name).to_s
      output_file = File.open(output_file_path, "w")

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

          column_type, limit = convert_mysql_column_type(type)

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

      output_file.close
      log "Successfully finished generating schema into #{output_file_path}"
    end

    def convert_mysql_column_type(t)
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

    def generate_id_field_name(table_name)
      "#{table_name.tableize.singularize}_id"
    end

    def import_mysql_data(prefix, namespace)
      db_conn_hash = {    host:     ENV["#{namespace.upcase}_MYSQL_HOST"],
                          port:     ENV["#{namespace.upcase}_MYSQL_PORT"],
                          database: ENV["#{namespace.upcase}_MYSQL_DB"],
                          username: ENV["#{namespace.upcase}_MYSQL_UID"],
                          password: ENV["#{namespace.upcase}_MYSQL_PWD"],
                          adapter:  'mysql2',
                          encoding: 'utf8',
                          pool:     5,
                          timeout:  5000 }

      connection = ActiveRecord::Base.establish_connection(db_conn_hash).connection

      table_names = []

      require "csv"

      table_results = connection.select_all("SHOW TABLES LIKE '#{prefix}%';")
      table_results.each do |tr|
        table_names << tr.values.first
      end

      connection.close

      table_names.each do |table_name|
        log "Importing mysql table #{table_name}"
        import_mysql_table(prefix, table_name, namespace)
      end

    end

    def import_mysql_table(prefix, table_name, namespace)
      db_conn_hash = {    host:     ENV["#{namespace.upcase}_MYSQL_HOST"],
                          port:     ENV["#{namespace.upcase}_MYSQL_PORT"],
                          database: ENV["#{namespace.upcase}_MYSQL_DB"],
                          username: ENV["#{namespace.upcase}_MYSQL_UID"],
                          password: ENV["#{namespace.upcase}_MYSQL_PWD"],
                          adapter:  'mysql2',
                          encoding: 'utf8',
                          pool:     5,
                          timeout:  5000 }

      connection = ActiveRecord::Base.establish_connection(db_conn_hash).connection

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

      class_name = "#{namespace.classify}::#{table_name[prefix.length..-1].singularize.classify}".constantize

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


    def log(m)
      puts "#{Time.now} - #{m}"
    end

    def convert_mssql_column_type(type_name, precision, scale)
      r_column_type = nil
      r_limit = nil
      r_precision = nil
      r_scale = nil

      if /int/.match(type_name)
        r_column_type = :integer
      elsif /nvarchar/.match(type_name) || /varchar/.match(type_name)
        r_column_type = :string
        r_limit = precision
      elsif /nchar/.match(type_name) || /char/.match(type_name)
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

    def generate_mssql_migration(output_file_name, prefix, namespace)
      db_conn_hash = {    host:     ENV["#{namespace.upcase}_MSSQL_HOST"],
                          port:     ENV["#{namespace.upcase}_MSSQL_PORT"],
                          database: ENV["#{namespace.upcase}_MSSQL_DB"],
                          username: ENV["#{namespace.upcase}_MSSQL_UID"],
                          password: ENV["#{namespace.upcase}_MSSQL_PWD"],
                          adapter:  'sqlserver',
                          pool:     5,
                          timeout:  5000 }

      connection = ActiveRecord::Base.establish_connection(db_conn_hash).connection

      output_file_path = Rails.root.join('tmp', output_file_name).to_s

      output_file = File.open(output_file_path, "w")

      table_results = connection.select_all("SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE='BASE TABLE' AND TABLE_NAME LIKE '#{prefix}%';")
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

          # puts "#{table_name} - #{column_name} - #{type_name} - length:#{length} - precision:#{precision} - scale: #{scale}"

          column_type, limit, precision, scale = convert_mssql_column_type(type_name, precision, scale)

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
        output_file.puts ""

      end

      output_file.puts ""
      output_file.close
      log "Successfully finished generating schema into #{output_file_path}"
    end

    def generate_mssql_definition(output_file_name, namespace)
      db_conn_hash = {    host:     ENV["#{namespace.upcase}_MSSQL_HOST"],
                          port:     ENV["#{namespace.upcase}_MSSQL_PORT"],
                          database: ENV["#{namespace.upcase}_MSSQL_DB"],
                          username: ENV["#{namespace.upcase}_MSSQL_UID"],
                          password: ENV["#{namespace.upcase}_MSSQL_PWD"],
                          adapter:  'sqlserver',
                          pool:     5,
                          timeout:  5000 }

      connection = ActiveRecord::Base.establish_connection(db_conn_hash).connection

      output_file_path = Rails.root.join('tmp', output_file_name).to_s

      output_file = File.open(output_file_path, "w")

      output_file.puts "#{db_conn_hash[:database]}"

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

  end
end
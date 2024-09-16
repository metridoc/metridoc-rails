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


    def export_legacy_mysql_data(prefix, export_folder)
      db_conn_hash = {    host:     ENV["LEGACY_MYSQL_HOST"],
                          port:     ENV["LEGACY_MYSQL_PORT"],
                          database: ENV["LEGACY_MYSQL_DB"],
                          username: ENV["LEGACY_MYSQL_UID"],
                          password: ENV["LEGACY_MYSQL_PWD"],
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
        export_legacy_mysql_table(table_name, export_folder)
      end

    end

    def export_legacy_mysql_table(mysql_table_name, export_folder)
      db_conn_hash = {    host:     ENV["LEGACY_MYSQL_HOST"],
                          port:     ENV["LEGACY_MYSQL_PORT"],
                          database: ENV["LEGACY_MYSQL_DB"],
                          username: ENV["LEGACY_MYSQL_UID"],
                          password: ENV["LEGACY_MYSQL_PWD"],
                          adapter:  'mysql2',
                          encoding: 'utf8',
                          pool:     5,
                          timeout:  5000 }

      connection = ActiveRecord::Base.establish_connection(db_conn_hash).connection

      require "csv"

      csv_file_path = File.join(export_folder, "#{mysql_table_name}.csv")

      log "Started exporting mysql table #{mysql_table_name}"

      row_results = connection.select_all("SELECT * FROM #{mysql_table_name};")

      CSV.open(csv_file_path, "wb") do |csv|
        if row_results.count > 0
          csv << row_results.first.keys
        end
        n = 0
        row_results.each do |row|
          csv << row.values
          n = n + 1
          log("Exported #{n} rows.") if n % 10000 == 0
        end
      end

      log "Finished exporting mysql table #{mysql_table_name}"

      connection.close
    end

    def import_legacy_csv(institution_code, export_folder, csv_name, target_model)
      institution_id = Institution.get_id_from_code(institution_code)
      class_name = target_model.constantize
      has_institution_id = class_name.has_attribute?('institution_id')
      batch_size = 10000

      if has_institution_id
        class_name.where(is_legacy: true, institution_id: institution_id).delete_all
      else
        class_name.where(is_legacy: true).delete_all
      end

      csv_file_path = File.join(export_folder, csv_name)

      require "csv"
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
        z.merge!(is_legacy: true)
        z.merge!(institution_id: institution_id) if has_institution_id
        headers.each_with_index do |k,i|
          z[k.underscore.to_sym] = row[i] if k != 'id' && class_name.has_attribute?(k.underscore)
        end
        records << class_name.new(z)

        if records.size >= batch_size
          success = false
          begin
            class_name.import records
            log "Imported #{records.size} records into #{target_model}"
            records = []
            success = true
          rescue => ex
            log "Error => #{ex.message}"
          end

          if !success
            log "Switching to individual mode"
            records.each do |record|
              unless record.save
                log "Failed saving #{record.inspect} error: #{records.errors.full_messages.join(", ")}"
              end
            end
            records = []
          end
        end

      end
      if records.size > 0
        success = false
        begin
          class_name.import records
          log "Imported #{records.size} records into #{target_model}"
          records = []
          success = true
        rescue => ex
          log "Error => #{ex.message}"
        end

        if !success
          log "Switching to individual mode"
          records.each do |record|
            unless record.save
              log "Failed saving #{record.inspect} error: #{records.errors.full_messages.join(", ")}"
            end
          end
          records = []
        end

      end

      log "#{n_errors} errors with #{target_model}" if n_errors > 0
      log "Finished importing #{target_model}"

      return true
    end

    def import_mysql_table(prefix, table_name, namespace)
      db_conn_hash = {    host:     ENV["LEGACY_MYSQL_HOST"],
                          port:     ENV["LEGACY_MYSQL_PORT"],
                          database: ENV["LEGACY_MYSQL_DB"],
                          username: ENV["LEGACY_MYSQL_UID"],
                          password: ENV["LEGACY_MYSQL_PWD"],
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

      yml_path = File.join(Rails.root, "config", "database.yml")
      app_db = Psych.safe_load_file(
        yml_path,
        aliases: true
      )

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


    def audit_query_insitutition(folder_name, sequences_only = [])
      output_file_path = Rails.root.join('tmp', "#{folder_name}.sql").to_s

      output_file = File.open(output_file_path, "w")
      output_file.puts "#{folder_name}:"
      output_file.puts "-----------------------------------------------------------------"
      output_file.close

      get_tasks_yamls(folder_name, sequences_only).each do |task|
        puts "Running task: #{task["load_sequence"]}"
        task["output_file_path"] = output_file_path
        if task["adapter"] == "sqlserver"
          break if !audit_query_mssql_table(task)
        elsif task["adapter"] == "native_sql"
          break if !audit_native_query(task)
        end
      end
    end

    def import_institution(folder_name, test_mode = false, sequences_only = [])
      get_tasks_yamls(folder_name, sequences_only).each do |task|
        puts "Running task: #{task["load_sequence"]}"
        #TODO Add other types of load here as well, such as mysql, csv, etc.
        if task["adapter"] == "sqlserver"
          break if !import_mssql_table(task, test_mode)
        elsif task["adapter"] == "native_sql"
          break if !execute_native_query(task)
        elsif task["adapter"] == "csv"
          break if !execute_csv_import(task, test_mode)
        elsif task["adapter"] == "console_command"
          break if !execute_console_command(task, test_mode)
        end
      end
    end

    def export_institution(folder_name, output_path, sequences_only = [])
      get_tasks_yamls(folder_name, sequences_only).each do |task|
        puts "Running task: #{task["load_sequence"]}"
        #TODO Add other types of load here as well, such as mysql
        if task["adapter"] == "sqlserver"
          export_from_mssql_table_to_csv(task, File.join(output_path, "#{task["target_model"]}.csv"))
        end
      end
    end

    def get_tasks_yamls(folder_name, sequences_only = [])
      sequences_only = [sequences_only] unless sequences_only.is_a?(Array)

      r = Rails.root.join('config','data_sources', folder_name)
      global_params = {}

      if File.exist?(r.join("global.yml"))
        global_params = Psych.safe_load(
          ERB.new(File.read(r.join("global.yml"))).result,
          aliases: true
        )
      end

      global_params.each do |k, v|
        next unless v.is_a?(String)
        m = v.match(/ENV\["([^\[\]"]*)"\]/)
        if m.present?
          global_params[k] = ENV[m[1]]
        end
      end

      full_paths = Dir.glob(r.join("**", "*"))
      tasks = []
      full_paths.each do |full_path|
        next if File.basename(full_path) == "global.yml"

        table_params = Psych.safe_load(
          ERB.new(File.read(full_path)).result,
          aliases: true
        )

        seq = table_params["load_sequence"] || 0

        next if sequences_only.present? && !seq.in?(sequences_only)

        tasks << global_params.merge(table_params)
      end

      tasks.sort_by!{|t| t["load_sequence"]}
    end

    def execute_native_query(params)
      institution_id = Institution.get_id_from_code(params["institution_code"])

      sqls = params["sqls"]

      sqls = [params["sql"]] if sqls.blank?

      target_model = params["target_model"]
      truncate_before_load = params["truncate_before_load"] == "yes"

      class_name = target_model.constantize
      has_institution_id = class_name.has_attribute?('institution_id')

      if truncate_before_load
        if has_institution_id
          class_name.where(institution_id: institution_id).delete_all
        else
          class_name.delete_all
        end
      end

      sqls.each do |sql|
        sql.gsub!('{{institution_id}}', institution_id.to_s)
        log "Executing Query #{sql}"
        ActiveRecord::Base.connection.execute(sql)
      end

      return true
    end

    def import_mssql_table(params, test_mode = false)
      csv_file_path =  Tempfile.new([params["target_model"],'.csv'], 'tmp').path
      export_from_mssql_table_to_csv(params, csv_file_path, test_mode)
      params["csv_file_path"] = csv_file_path
      params["bypass_validations"] = true

      return import_csv(params, test_mode)
    end

    def execute_csv_import(params, test_mode = false)
      params["csv_file_path"] = File.join(params["root_path"], params["file_name"])

      return import_csv(params, test_mode)
    end

    def execute_console_command(params, test_mode)
      cmds = params["commands"]

      cmds = [params["command"]] if cmds.blank?

      cmds.each do |cmd|
        puts "Executing: #{cmd}"
        if ! system(cmd)
          puts "Command Failed."
          return false
        end
      end

      return true
    end

    def import_csv(params, test_mode = false)
      institution_id = Institution.get_id_from_code(params["institution_code"])
      target_model = params["target_model"]
      class_name = target_model.constantize
      csv_file_path = params["csv_file_path"]
      truncate_before_load = params["truncate_before_load"] == "yes"
      has_institution_id = class_name.has_attribute?('institution_id')

      log "Has Institution [#{params["institution_code"]}] [#{institution_id}]." if has_institution_id

      if truncate_before_load
        if has_institution_id
          class_name.where(institution_id: institution_id).delete_all
        else
          class_name.delete_all
        end
      end

      require "csv"
      csv = CSV.read(csv_file_path)

      headers = csv.first

      batch_size = test_mode ? 100 : 10000

      records = []
      n_errors = 0
      csv.drop(1).each_with_index do |row, n|
        if n_errors >= 100
          log "Too may errors #{n_errors}, exiting!"
          records = []
          break
        end
        z = {}
        z.merge!(institution_id: institution_id) if has_institution_id
        headers.each_with_index do |k,i|
          v = row[i]
          #validations
          unless params["bypass_validations"]
            if class_name.columns_hash[k.underscore].type == :integer && !valid_integer?(v)
              log "Invalid integer #{v} in #{row.join(",")}"
              n_errors = n_errors + 1
              next
            end
            if class_name.columns_hash[k.underscore].type == :datetime && !valid_datetime?(v)
              log "Invalid datetime #{v} in #{row.join(",")}"
              n_errors = n_errors + 1
              next
            end
            if class_name.columns_hash[k.underscore].type == :date && !valid_datetime?(v)
              log "Invalid date #{v} in #{row.join(",")}"
              n_errors = n_errors + 1
              next
            end
          end

          z[k.underscore.to_sym] = v
        end
        records << class_name.new(z)

        if records.size >= batch_size
          success = false
          begin
            class_name.import records
            log "Imported #{records.size} records into #{target_model}"
            records = []
            success = true
          rescue => ex
            log "Error => #{ex.message}"
          end

          if !success
            log "Switching to individual mode"
            records.each do |record|
              unless record.save
                log "Failed saving #{record.inspect} error: #{records.errors.full_messages.join(", ")}"
              end
            end
            records = []
          end

          break if test_mode
        end

      end
      if records.size > 0
        success = false
        begin
          class_name.import records
          log "Imported #{records.size} records into #{target_model}"
          records = []
          success = true
        rescue => ex
          log "Error => #{ex.message}"
        end

        if !success
          log "Switching to individual mode"
          records.each do |record|
            unless record.save
              log "Failed saving #{record.inspect} error: #{records.errors.full_messages.join(", ")}"
            end
          end
          records = []
        end

      end

      log "#{n_errors} errors with #{target_model}" if n_errors > 0
      log "Finished importing #{target_model}"

      return true
    end

  def export_from_mssql_table_to_csv(params, csv_file_path, test_mode = false)
    mssql_helper = ImportHelper::Mssql.new(params, csv_file_path, test_mode)
    mssql_helper.export_table_to_csv
  end

    def audit_query_mssql_table(params)

      output_file_path = params["output_file_path"]
      target_model = params["target_model"]
      filter = params["filter"]
      distinct = params["select_distinct"]
      select_sql = params["select_sql"]
      source_tables = params["source_tables"]
      group_by_sql = params["group_by_sql"]

      log "Started exporting #{target_model}"

      sql =  " SELECT #{distinct ? "DISTINCT" : ""} " + select_sql + "\n" +
             " FROM " + source_tables + "\n" +
             " WHERE 1=1 " + "\n"
      sql += " AND (#{filter}) " + "\n" if filter.present?
      sql += " GROUP BY " + group_by_sql + "\n" if group_by_sql.present?

      output_file = File.open(output_file_path, "a")
      output_file.puts "#{target_model}:"
      output_file.puts ""
      output_file.puts sql
      output_file.puts ""
      output_file.puts "-----------------------------------------------------------------"
      output_file.close

      return true
    end

    def audit_native_query(params)
      institution_id = Institution.get_id_from_code(params["institution_code"])
      output_file_path = params["output_file_path"]
      sqls = params["sqls"]
      sqls = [params["sql"]] if sqls.blank?
      target_model = params["target_model"]

      output_file = File.open(output_file_path, "a")
      output_file.puts "#{target_model}:"
      output_file.puts ""

      sqls.each do |sql|
        sql.gsub!('{{institution_id}}', institution_id.to_s)
        output_file.puts sql
        output_file.puts ""
      end

      output_file.puts ""
      output_file.puts "-----------------------------------------------------------------"

      output_file.close

      return true
    end

  end
end

def valid_integer?(v)
  return v.blank? || v.match(/\A[+-]?\d+\z/).present?
end

def valid_datetime?(v)
  return true if v.blank?
  begin
     DateTime.parse(v)
  rescue ArgumentError
     return false
  end
  return true
end

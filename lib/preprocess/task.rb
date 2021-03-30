require "csv"
require 'chronic'

module Preprocess

  class Task

    def initialize(main_driver, task_file, test_mode = false)
      @main_driver, @task_file, @test_mode = main_driver, task_file, test_mode
    end

    def log_job_execution
      @main_driver.log_job_execution
    end

    def log_job_execution_step
      return @log_job_execution_step if @log_job_execution_step.present?

      @log_job_execution_step = log_job_execution.job_execution_steps.create!(
        step_name: task_config["load_sequence"],
        step_yml: task_config,
        started_at: Time.now,
        status: 'running'
      )
    end

    def global_config
      @main_driver.global_config
    end

    def institution_id
      @main_driver.institution_id
    end

    def do_validations?
      task_config["do_validations"] == "yes"
    end

    def target_mappings(headers = nil)
      return @target_mappings if @target_mappings.present?

      return @target_mappings = task_config['target_mappings'] if task_config['target_mappings'].present?

      if task_config["column_mappings"].present?
        @target_mappings = task_config["column_mappings"].map { |column, target_column| { target_column.to_s.strip => target_column.to_s.strip } }.inject(:merge)
      else
        @target_mappings = headers.map { |column| class_name.has_attribute?(column.underscore) ? { column.to_s.strip.underscore => column.to_s.strip.underscore } : nil }.compact.inject(:merge)
      end

      return @target_mappings
    end

    def task_config
      return @task_config unless @task_config.blank?
      @task_config = global_config.merge(YAML.load_file(@task_file))
    end

    def target_adapter
      task_config["target_adapter"] || task_config["adapter"]
    end

    def execute
      log_job_execution_step

      return_value = false
      if target_adapter == "csv"
        return_value = preprocess
      elsif target_adapter == "xml"
        # Too big of a change to preprocess XML here, so keep doing it during the import
        return_value = true
      elsif target_adapter == "native_sql"
        return_value = true
      elsif target_adapter == "console_command"
        return_value = true
      else
        raise "Unsupported target_adapter type >> #{target_adapter}"
      end

      if return_value
        log_job_execution_step.set_status!("successful")
      else
        log_job_execution_step.set_status!("failed")
      end

      return return_value

    rescue => ex
      log "Error => [#{ex.message}]"
      log_job_execution_step.set_status!("failed")
      return false
    end

    def batch_size
      @test_mode ? 100 : task_config["batch_size"] || 10000
    end

    def class_name
      return @class_name if @class_name.present?
      @class_name = task_config["target_model"].constantize
    end

    def has_created_at?
      class_name.has_attribute?('created_at')
    end

    def has_institution_id?
      class_name.has_attribute?('institution_id')
    end

    def has_legacy_flag?
      class_name.has_attribute?('is_legacy')
    end

    def has_updated_at?
      class_name.has_attribute?('updated_at')
    end

    def legacy_filter_date_field
      task_config["legacy_filter_date_field"]
    end

    def sqls
      return @sqls if @sqls.present?
      @sqls = task_config["sqls"].present? ? task_config["sqls"] : [task_config["sql"]]
    end

    def commands
      return @commands if @commands.present?
      @commands = task_config["commands"].present? ? task_config["commands"] : [task_config["command"]]
    end

    def execute_console_command
      commands.each do |cmd|
        log "Executing: #{cmd}"
        if !system(cmd)
          log "Command #{cmd} Failed."
          return false
        end
      end

      return true
    end

    def execute_native_query
      truncate if truncate_before_load?

      sqls.each do |sql|
        sql = sql % { institution_id: institution_id }
        log "Executing Query [#{sql}]"
        ActiveRecord::Base.connection.execute(sql)
      end

      return true
    end

    def import_file_name
      task_config["import_file_name"] || task_config["export_file_name"] || task_config["file_name"]
    end

    def transformations
      task_config["transformations"] || {}
    end

    def csv_file_path
      @csv_file_path ||= File.join(@main_driver.import_folder, import_file_name)
    end

    def get_headers
      csv = CSV.open(csv_file_path, { external_encoding: global_config['encoding'] || 'UTF-8', internal_encoding: 'UTF-8' })
      columns = csv.readline
      csv.close
      headers = columns.map { |c| Util.column_to_attribute(c) }
      headers.each do |column_name|
        if class_name.columns_hash[column_name].blank?
          headers[headers.index(column_name)] = column_name.split(/_+/).first
        end
      end
      headers
    end

    def output_headers(headers)
      # this insures that the correct header fields are output (in some
      # cases not all of the csv's columns are used in Metridoc table.)
      _output_headers = target_mappings(headers).keys
      _output_headers.unshift("institution_id") if has_institution_id?
      _output_headers << 'created_at' if has_created_at?
      _output_headers << 'updated_at' if has_updated_at?
      _output_headers
    end

    def preprocess
      log "Starting to preprocess #{import_file_name}"

      transformations.each do |column, rules|
        transformations[column]["engine"] = lambda do |v|
          rules.each do |rule, val|
            return val if /#{rule}/i.match(v)
          end
          return v
        end
      end

      header_converter = lambda { |header| header.downcase }
      csv = CSV.parse(File.read(csv_file_path, encoding: 'bom|utf-8'), headers: true, header_converters: header_converter)
      temp_file = Tempfile.new("#{import_file_name}.tmp")
      temp_csv = CSV.open(temp_file, 'wb')

      timestamp = DateTime.now.to_s
      n_errors = 0
      headers = csv.headers
      temp_csv << output_headers(headers)

      csv.each do |row|
        if n_errors >= 100
          log "Too many errors #{n_errors}, exiting!"
          break
        end

        cols = {}
        headers.each_with_index do |k, i|
          cols[k.to_s.strip.underscore.to_sym] = row[i]
        end

        row_error = false
        atts = {}
        atts.merge!(institution_id: institution_id) if has_institution_id?
        target_mappings(headers).each do |column_name, target_column|
          if cols.key?(target_column.to_sym)
            val = cols[target_column.to_sym]
          else
            val = target_column % cols
          end

          val = transformations[column_name]["engine"].call(val) if transformations[column_name].present?

          if do_validations?
            if class_name.columns_hash[column_name].type == :integer && !valid_integer?(val)
              log "Invalid integer #{val} in #{row.join(",")}"
              n_errors = n_errors + 1
              row_error = true
              next
            end
            if class_name.columns_hash[column_name].type == :datetime && !valid_datetime?(val)
              log "Invalid datetime #{val} in #{row.join(",")}"
              n_errors = n_errors + 1
              row_error = true
              next
            end
            if class_name.columns_hash[column_name].type == :date && !valid_datetime?(val)
              log "Invalid date #{val} in #{row.join(",")}"
              n_errors = n_errors + 1
              row_error = true
              next
            end
          end

          val = Chronic.parse(val) if class_name.columns_hash[column_name].type == :datetime

          atts[column_name] = val
        end

        atts[:created_at] = timestamp if has_created_at?
        atts[:updated_at] = timestamp if has_updated_at?

        temp_csv << atts.map { |k, v| v }
        next if row_error

      end

      temp_csv.close
      temp_file.close
      FileUtils.mv(temp_file.path, csv_file_path)

      log "#{n_errors} errors" if n_errors > 0
      log "Finished preprocessing #{import_file_name}."

      return true
    end

    def iterator_path
      task_config["iterator_path"]
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

    def log(m)
      log = "#{Time.now} - #{m}"
      log_job_execution_step.log_line(log)
      puts log
    end

  end

  # class Task

end

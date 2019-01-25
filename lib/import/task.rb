require "csv"
require 'chronic'

module Import

    class Task

      attr_accessor :main_driver, :task_file, :test_mode
      def initialize(main_driver, task_file, test_mode = false)
        @main_driver, @task_file, @test_mode = main_driver, task_file, test_mode
      end

      def global_config
        main_driver.global_config
      end

      def institution_id
        @main_driver.institution_id
      end

      def do_validations?
        task_config["do_validations"] == "yes"
      end

      def truncate_before_load?
        task_config["truncate_before_load"] == "yes"
      end

      def target_mappings(headers)
        return @target_mappings if @target_mappings.present?

        return @target_mappings = task_config['target_mappings'] if task_config['target_mappings'].present?

        if task_config["column_mappings"].present?
          @target_mappings = task_config["column_mappings"].map{|column, target_column| {target_column => target_column} }.inject(:merge)
        else
          @target_mappings = headers.map{|column| class_name.has_attribute?(column.underscore) ? {column.underscore => column.underscore} : nil }.compact.inject(:merge)
        end

        return @target_mappings
      end

      def task_config
        return @task_config unless @task_config.blank?
        @task_config = global_config.merge(YAML.load_file(task_file))
      end

      def target_adapter
        task_config["target_adapter"] || task_config["adapter"]
      end

      def execute
        if target_adapter == "csv"
          return import
        elsif target_adapter == "native_sql"
          return execute_native_query
        elsif target_adapter == "console_command"
          return execute_console_command
        else
          raise "Unsupported target_adapter type >> #{target_adapter}"
        end
        return false
      end

      def batch_size
        test_mode ? 100 : task_config["batch_size"] || 10000
      end

      def class_name
        return @class_name if @class_name.present?
        @class_name = task_config["target_model"].constantize
      end

      def has_institution_id?
        class_name.has_attribute?('institution_id')
      end

      def has_legacy_flag?
        class_name.has_attribute?('is_legacy')
      end

      def truncate
        filters = {}
        filters.merge!(institution_id: institution_id) if has_institution_id?
        filters.merge!(is_legacy: false) if has_legacy_flag? && task_config["truncate_legacy_data"] != "yes"

        class_name.where(filters).delete_all
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
          if ! system(cmd)
            log "Command #{cmd} Failed."
            return false
          end
        end

        return true
      end

      def execute_native_query
        truncate if truncate_before_load?

        sqls.each do |sql|
          sql = sql % {institution_id: institution_id}
          log "Executing Query #{sql}"
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

      def import
        log "Starting to import #{import_file_name}"

        csv_file_path = File.join(@main_driver.import_folder, import_file_name)

        transformations.each do |column, rules|
          transformations[column]["engine"] = lambda do |v|
            rules.each do |rule, val|
              return val if /#{rule}/i.match(v)
            end
            return v
          end
        end

        truncate if truncate_before_load?

        csv = CSV.read(csv_file_path, {encoding: 'ISO-8859-1'})

        headers = csv.first

        records = []
        n_errors = 0
        csv.drop(1).each_with_index do |row, n|
          if n_errors >= 100
            log "Too many errors #{n_errors}, exiting!"
            records = []
            break
          end

          cols = {}
          headers.each_with_index do |k,i| 
            cols[k.underscore.to_sym] = row[i]
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

          next if row_error

          records << class_name.new(atts)

          if records.size >= batch_size
            n_errors += import_records(records)
            records = []
            break if test_mode
          end

        end

        if records.size > 0
          n_errors += import_records(records)
          records = []
        end

        log "#{n_errors} errors" if n_errors > 0
        log "Finished importing #{import_file_name}."

        return true
      end

      def import_records(records)
        begin
          class_name.import records
          log "Imported #{records.size} records."
          return 0
        rescue => ex
          log "Error => #{ex.message}"
        end

        n_errors = 0
        log "Switching to individual mode"
        records.each do |record|
          begin
            unless record.save
              log "Failed saving #{record.inspect} error: #{records.errors.full_messages.join(", ")}"
              n_errors += 1
            end
          rescue => ex
            log "Error => #{ex.message} record:[#{record.inspect}]"
            n_errors += 1
            record.attribute_names.each do |a|
              log "#{a} --- #{record.send(a).size rescue "n/a"} "
            end
          end
        end

        return n_errors
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
        puts "#{Time.now} - #{m}"
      end

    end # class Task

end

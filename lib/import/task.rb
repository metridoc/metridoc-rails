require "csv"
require 'chronic'

module Import

    class Task

      def initialize(main_driver, step, test_mode = false)
        @main_driver, @step, @test_mode = main_driver, step, test_mode
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

      def truncate_before_load?
        task_config["truncate_before_load"] == "yes"
      end

      def target_mappings(headers = nil)
        return @target_mappings if @target_mappings.present?

        return @target_mappings = task_config['target_mappings'] if task_config['target_mappings'].present?

        if task_config["column_mappings"].present?
          @target_mappings = task_config["column_mappings"].map{|column, target_column| {target_column.to_s.strip => target_column.to_s.strip} }.inject(:merge)
        else
          @target_mappings = headers.map{|column| class_name.has_attribute?(column.underscore) ? {column.to_s.strip.underscore => column.to_s.strip.underscore} : nil }.compact.inject(:merge)
        end

        return @target_mappings
      end

      def task_config
        return @task_config unless @task_config.blank?
        @task_config = global_config.merge(@step.attributes)
      end

      def target_adapter
        task_config["target_adapter"] || task_config["adapter"]
      end

      def execute
        log_job_execution_step

        return_value = false
        if target_adapter == "csv"
          return_value = import_csv
        elsif target_adapter == "xml"
          return_value = import_xml
        elsif target_adapter == "native_sql"
          return_value = execute_native_query
        elsif target_adapter == "console_command"
          return_value = execute_console_command
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

      def has_institution_id?
        class_name.has_attribute?('institution_id')
      end

      def has_legacy_flag?
        class_name.has_attribute?('is_legacy')
      end

      def legacy_filter_date_field
        task_config["legacy_filter_date_field"]
      end

      def truncate
        filters = {}
        filters.merge!(institution_id: institution_id) if has_institution_id?

        if has_legacy_flag? && task_config["truncate_legacy_data"] != "yes"
          filters.merge!(is_legacy: false)
          # mark records older than 1 year old as legacy
          if legacy_filter_date_field.present?
            log "Setting Legacy Flag for #{class_name.name} records older than 1 year."
            class_name.where(filters).where(class_name.arel_table[legacy_filter_date_field].lt(1.year.ago)).update_all(is_legacy: true)
          end
        end


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
          log "Executing Query [#{sql}]"
          ActiveRecord::Base.connection.execute(sql)
        end

        return true
      end

      def import_file_name
        return task_config["import_file_name"] if task_config["import_file_name"].present?
        return task_config["export_file_name"] if task_config["export_file_name"].present?
        task_config["file_name"]
      end

      def import_csv
        truncate if truncate_before_load?

        csv_file_path = File.join(@main_driver.import_folder, import_file_name)
        table_name = class_name.table_name
        external_encoding = global_config['encoding'] || 'UTF-8'

        log "Starting to import #{import_file_name}"
        return_value = bulk_import(csv_file_path, table_name)
        log "Finished importing #{import_file_name}."

        return return_value[0]
      end

      def self.bulk_import(csv_file_path, table_name, external_encoding = 'UTF-8')
        csv = CSV.open(csv_file_path, {external_encoding: external_encoding, internal_encoding: 'UTF-8'})
        headers = csv.readline.map{|c| c.gsub(/[\s\/]+/, '_').downcase }.join(',')
        csv.close

        password = YAML.parse_file(Rails.root + "config" + "database.yml").to_ruby[Rails.env]['password']
        username = YAML.parse_file(Rails.root + "config" + "database.yml").to_ruby[Rails.env]['username']
        database = YAML.parse_file(Rails.root + "config" + "database.yml").to_ruby[Rails.env]['database']
        host = YAML.parse_file(Rails.root + "config" + "database.yml").to_ruby[Rails.env]['host']

        cmd = "PGPASSWORD='#{password}' psql -U#{username} -h #{host} -d #{database} -c \
              \"\\copy #{table_name}(#{headers}) FROM '#{csv_file_path}' WITH DELIMITER ',' HEADER CSV\""

        system(cmd)

        return [true, ""]
        rescue => error
          return [false, error.inspect]
      end

      def import_records(records)
        begin
          class_name.import records
          log "Imported #{records.size} records."
          return 0
        rescue => ex
          log "Error on import. Query too large to display."
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
            # record.attribute_names.each do |a|
            #   log "#{a} --- #{record.send(a).size rescue "n/a"} "
            # end
          end
        end

        return n_errors
      end

      def iterator_path
        task_config["iterator_path"]
      end

      def import_xml
        log "Starting to import XML #{import_file_name}"

        xml_file_path = File.join(@main_driver.import_folder, import_file_name)

        truncate if truncate_before_load?

        doc = Nokogiri::XML( File.open(xml_file_path) )
        doc.remove_namespaces!
        records = []
        n_errors = 0
        doc.xpath(iterator_path).each do |xml_row|
          row_error = false
          atts = {}
          atts.merge!(institution_id: institution_id) if has_institution_id?
          target_mappings.each do |column_name, x_path|
            node = xml_row.xpath(x_path)
            val = node.is_a?(Nokogiri::XML::NodeSet) ? (node.present? ? node.first.text : "") : node
            atts[column_name] = val.gsub(/\s+/, ' ').to_s.strip
          end

          next if row_error

          records << class_name.new(atts)

          if records.size >= batch_size
            n_errors += import_records(records)
            records = []
            break if @test_mode
          end

        end

        if records.size > 0
          n_errors += import_records(records)
          records = []
        end

        log "#{n_errors} errors" if n_errors > 0
        log "Finished importing XML #{import_file_name}."

        return true
      end

      def log(m)
        log = "#{Time.now} - #{m}"
        log_job_execution_step.log_line(log)
        puts log
      end

    end # class Task

end

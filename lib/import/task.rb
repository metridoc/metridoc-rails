require "csv"
require 'chronic'

module Import

    class Task

      HEADER_CONVERTER = ->(header) { Util.column_to_attribute(header).to_sym }

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

      def truncate_before_load?
        task_config["truncate_before_load"] == "yes"
      end

      def target_mappings(headers = nil)
        return @target_mappings if @target_mappings.present?

        return @target_mappings = task_config['target_mappings'] if task_config['target_mappings'].present?

        if task_config["column_mappings"].present?
          @target_mappings = task_config["column_mappings"].map{
            |column, target_column| {
              target_column.to_s.strip => target_column.to_s.strip
              }
            }.inject(:merge)
        else
          @target_mappings = headers.map{
            |column| class_name.has_attribute?(column.underscore) ? {column.to_s.strip.underscore => column.to_s.strip.underscore} : nil
          }.compact.inject(:merge)
        end

        return @target_mappings
      end

      def task_config
        return @task_config unless @task_config.blank?
        @task_config = global_config.merge(
          Psych.load_file(@task_file)
        )
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

      def max_errors
        2000
      end

      def class_name
        return @class_name if @class_name.present?
        @class_name = task_config["target_model"].constantize
      end

      # Connect to the database and get the column information
      # Any hidden columns will be picked up by this method
      def columns_hash
        return @columns_hash if @columns_hash.present?
        @columns_hash =  ActiveRecord::Base.connection.schema_cache.columns_hash(class_name.table_name)
      end

      def has_institution_id?
        class_name.has_attribute?('institution_id')
      end

      # Extract the constructor for a checksum index
      def checksum_index 
        return @checksum_index if @checksum_index.present?
        @checksum_index = task_config['checksum_index']
      end

      # Query the existance of a checksum index
      def has_checksum_index?
        task_config.has_key?('checksum_index')
      end

      def has_legacy_flag?
        class_name.has_attribute?('is_legacy')
      end

      def legacy_filter_date_field
        task_config["legacy_filter_date_field"]
      end

      # fetch any unique keys specified in the task config file
      def unique_keys
        task_config["unique_keys"]
      end

      # Task config to set the upsert rule
      # Default is false
      def upsert
        task_config["upsert"] | false
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

        # If there are no filters, do a true truncate of the table
        if filters.empty? 
          ActiveRecord::Base.connection.execute(
            "TRUNCATE #{class_name.table_name} RESTART IDENTITY"
          )
        else
          # Otherwise, only delete the records selected by the filters
          class_name.where(filters).delete_all
        end
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
          begin
            sql = sql % {institution_id: institution_id} if has_institution_id?
            log "Executing Query [#{sql}]"
            ActiveRecord::Base.connection.execute(sql)
          rescue SignalException => e
            log "Recieved Exception: #{e}"
            log_job_execution_step.set_status!("failed")
            log_job_execution.set_status!("failed")
            return false
          end
        end

        return true
      end

      def import_file_name
        task_config["import_file_name"] || task_config["export_file_name"] || task_config["file_name"]
      end

      def csv_file_path
        @csv_file_path ||= File.join(@main_driver.import_folder, import_file_name)
      end

      def get_headers
        csv = CSV.open(
          csv_file_path,
          external_encoding: global_config.fetch("encoding", "UTF-8"),
          internal_encoding: 'UTF-8'
        )
        columns = csv.readline
        csv.close
        headers = columns.map{|c| Util.column_to_attribute(c) }
        headers.each do |column_name|
          if columns_hash[column_name].blank?
            headers[headers.index(column_name)] = column_name.split(/\_+/).first
          end
        end
        headers
      end

      def import_csv
        # Get the header from the csv file
        headers = get_headers

        # Query the class for any ignored columns
        # If there are ignored columns, the upload must proceed in a different way
        has_ignored_columns = class_name.ignored_columns.any?
        if has_ignored_columns
          log "!!CAVEAT!!: These columns will not be visible via the GUI: [#{class_name.ignored_columns.join(", ")}]"
        end

        # Search for unmached columns between the header and the target mapping
        # Provide a warning for columns that will not be loaded
        unmatched_columns = headers.select { |column_name| columns_hash[column_name].blank? }
        if unmatched_columns.present?
          log "!!WARNING!!: These columns are not processed: [#{unmatched_columns.join(", ")}]"
        end

        n_errors = 0
        success = true
        ActiveRecord::Base.transaction do
          truncate if truncate_before_load?

          records = []

          csv = CSV.open(csv_file_path, headers: true,  header_converters: HEADER_CONVERTER)

          loop do
            begin
              if n_errors >= max_errors
                log "Too many errors #{n_errors}, exiting!"
                records = []
                success = false
                break
              end

              row = csv.shift
              break unless row

              row_error = false
              attributes = {}
              # Loop through all the columns for the row
              headers.each do |column_name|
                # Skip the column if it is not part of the table structure
                next if columns_hash[column_name].blank?

                val = row[column_name.to_sym]

                # Skip rows with invalid integers, datetimes or dates.
                if columns_hash[column_name].type == :integer && !Util.valid_integer?(val)
                  log "Invalid integer [#{val}] in column: #{column_name} row: #{row.to_h}"
                  n_errors = n_errors + 1
                  row_error = true
                  next
                end
                if columns_hash[column_name].type == :datetime && !Util.valid_datetime?(val)
                  log "Invalid datetime [#{val}] in column: #{column_name} row: #{row.to_h}"
                  n_errors = n_errors + 1
                  row_error = true
                  next
                end
                if columns_hash[column_name].type == :date && !Util.valid_datetime?(val)
                  log "Invalid date [#{val}] in column: #{column_name} row: #{row.to_h}"
                  n_errors = n_errors + 1
                  row_error = true
                  next
                end

                # Skip rows where designated strings are too long
                unless val.nil?
                  if columns_hash[column_name].type == :string
                    # if there isn't a length limit on the field, then keep going
                    unless columns_hash[column_name].sql_type_metadata.limit.nil?
                      if val.length > columns_hash[column_name].sql_type_metadata.limit
                        log "Length of value [#{val}] exceeds maximum for column #{column_name} row: #{row.to_h}"
                        n_errors = n_errors + 1
                        row_error = true
                        next
                      end
                    end
                  end
                end

                # Parse the datetime into the appropriate formats
                val = Util.parse_datetime(val) if columns_hash[column_name].type == :datetime
                val = Util.parse_datetime(val) if columns_hash[column_name].type == :date

                # Parse the json object from a string
                val = JSON.parse(val) if columns_hash[column_name].type == :json

                attributes[column_name] = val
              end

              next if row_error

              # Add an institution identifier to the attributes list if necessary
              attributes.merge!(institution_id: institution_id) if has_institution_id?

              # Add a checksum column if one is needed.
              # This creates an md5 hash based on a list of columns 
              # provided in the configuration file.
              if has_checksum_index?
                checksum_columns = checksum_index.map{ 
                  |ci| attributes.fetch(ci, nil) 
                }
                val = Digest::MD5.hexdigest(checksum_columns.join())
                attributes.merge!(checksum_index: val)
              end
              
              # Make sure all the keys are strings
              attributes.stringify_keys!

              if has_ignored_columns
                # Uploads with ignored columns must be made explicitly via SQL
                # Pass the hash object rather than a model
                records << attributes
              else
                # Typical imports require models to be passed
                records << class_name.new(attributes)
              end

              if records.size >= batch_size
                if has_ignored_columns
                  # Upload via sql commands
                  n_errors += import_records_with_ignored_columns(class_name, records)
                else
                  n_errors += import_records(records)
                end
                records = []
              end

            rescue CSV::MalformedCSVError => e
              n_errors = n_errors + 1
              log "skipping bad row - MalformedCSVError: #{e.message}"
            end
          end # loop

          csv.close

          if records.size > 0
            if has_ignored_columns
              n_errors += import_records_with_ignored_columns(class_name, records)
            else
              n_errors += import_records(records)
            end
            records = []
          end

          if n_errors >= max_errors
            log "Too many errors #{n_errors}."
            success = false
          else
            log "Finished importing #{class_name.model_name.human}."
          end

          unless success
            raise ActiveRecord::Rollback, "Rolling back the upload."
          end
        end # ActiveRecord::Base.transaction

        return success
      end

      # Explicitly import via SQL models that contain ignored columns.
      # This code is modified from the ActiveRecord-Import gem
      def import_records_with_ignored_columns(class_name, records)
        connection = ActiveRecord::Base.connection

        # Extract column names from SQL instead of via model
        column_names = columns_hash.keys

        # Get a list of column names quoted
        columns_sql = "(#{column_names.map { |name| connection.quote_column_name(name) }.join(',')})"
        # Build the beginning of the insert command
        insert_sql = "INSERT INTO #{class_name.quoted_table_name} #{columns_sql} VALUES "

        # Build the options for handling of unique keys
        options = {}
        if unique_keys.present? and upsert
          # Upsert Option for Duplicates
          # Allow a list of updateable columns from the config file
          options[:on_duplicate_key_update] = {
            conflict_target: unique_keys,
            columns: task_config["upsert_columns"] || column_names
          }
        elsif unique_keys.present?
          # Ignore Duplicates
          options[:on_duplicate_key_ignore] = true
        end

        # Pass the primary key flag to track the id sequence
        options[:primary_key] = class_name.primary_key

        # Pass the model name through options
        options[:model] = class_name

        # Create the post sql statements for upsert or ignore duplicates
        post_sql_statements = connection.post_sql_statements(
          class_name.quoted_table_name, **options
        )

        # Get the prepared set of values for sql insertion
        values_sql = construct_values_sql(class_name, records)

        # Insert records
        result = connection.insert_many(
          [insert_sql, post_sql_statements].flatten,
          values_sql,
          options,
          "#{class_name} Create Many"
        )

        log "Imported #{result.ids.size} records."
        log_validation_errors(result.failed_instances)
        return result.failed_instances.size
      end

      # Loosely based on values_sql_for_columns_and_attributes from
      # ActiveRecord Import.
      # Returns SQL the VALUES for an INSERT statement given the passed
      # in +class_name+ and +records+.
      def construct_values_sql(class_name, records)
        # Connection gets called a *lot* in this high intensity loop.
        # Reuse the same one w/in the loop, otherwise it would keep being
        # re-retreived (= lots of time for large imports)
        connection = ActiveRecord::Base.connection
        # Transform the array of hashes into an array of (val0, val1, ...)
        # for SQL import
        records.map do |record|
          values = columns_hash.keys.map do |column_name|
            if column_name == class_name.primary_key
              # Fill in the id value from the sequential id table
              connection.next_value_for_sequence(class_name.sequence_name)
            else
              # Get the column value from the record, using NULL as default
              value = record.fetch(column_name, nil)

              # Format any yaml or json values for upload into the database
              value = class_name.type_for_attribute(column_name).serialize(value)
              connection.quote(value)
            end
          end
          "(#{values.join(',')})"
        end
      end

      def import_records(records)
        begin
          # Handle unique keys with specified duplicate behavior
          result =
            if unique_keys.present? and upsert
              class_name.import records, on_duplicate_key_update: {
                conflict_target: unique_keys,
                columns: :all
              }
            elsif unique_keys.present?
              class_name.import records, on_duplicate_key_ignore: true
            else
              class_name.import records
            end

          log "Imported #{result.ids.size} records."
          log_validation_errors(result.failed_instances)
          return result.failed_instances.size
        rescue
          log "Error on import. Query too large to display."
          return save_records_individually(records)
        end
      end

      def save_records_individually(records)
        n_errors = 0
        log "Switching to individual mode"
        records.each do |record|
          begin
            # save will update an existing record instead of adding a new one
            unless record.save
              log "Failed saving #{record.inspect} error: #{record.errors.full_messages.join(", ")}"
              n_errors += 1
            end
          rescue => ex
            log "Error => #{ex.message} record:[#{record.inspect}]"
            n_errors += 1
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

      def log_validation_errors(records)
        records.each do |r|
          log "Failed saving #{r.inspect} error: #{r.errors.full_messages.join(", ")}"
        end
      end

      def log(m)
        log = "#{Time.now} - #{m}"
        log_job_execution_step.log_line(log)
        puts log
      end

    end # class Task

end

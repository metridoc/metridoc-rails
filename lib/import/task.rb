require "csv"

module Import

    class Task

      attr_accessor :mssql_main, :task_file, :test_mode
      def initialize(mssql_main, task_file, test_mode = false)
        @mssql_main, @task_file, @test_mode = mssql_main, task_file, test_mode
      end

      def global_config
        mssql_main.global_config
      end

      def institution_id
        @mssql_main.institution_id
      end

      def test_mode
        @test_mode
      end

      def do_validations?
        task_config["do_validations"] == "yes"
      end

      def truncate_before_load?
        task_config["truncate_before_load"] == "yes"
      end

      def target_mappings
        task_config['target_mappings']
      end

      def task_config
        return @task_config unless @task_config.blank?
        @task_config = global_config.merge(YAML.load_file(task_file))
      end

      def execute
        if task_config["adapter"] == "csv"
          import
        elsif task_config["adapter"] == "native_sql"
          execute_native_query
        elsif task_config["adapter"] == "console_command"
          execute_console_command
        end
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

      def truncate
        class_name.where(has_institution_id? ? {institution_id: institution_id} : nil).delete_all
      end

      def sqls
        return @sqls if @sqls.present?
        @sqls = task_config["sqls"].present? ? task_config["sqls"] : [task_config["sql"]]
      end

      def commands
        return @commands if @commands.present?
        @commands = task_config["commands"].present? ? task_config["commands"] : [task_config["command"]]
      end

      def execute_console_command(params, test_mode)
        cmds.each do |cmd|
          log "Executing: #{cmd}"
          if ! system(cmd)
            log "Command Failed."
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

      def import
        csv_file_path = File.join(global_config["export_folder"], "#{task_config["source_table"].downcase}.csv")

        truncate if truncate_before_load?

        csv = CSV.read(csv_file_path)

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

          atts = {}
          atts.merge!(institution_id: institution_id) if has_institution_id?
          target_mappings.each do |k, v|
            if cols[v].present?
              atts[k.to_sym] = cols[v]
            else
              atts[k.to_sym] = v % cols
            end
            if do_validations?
              if class_name.columns_hash[k.to_sym].type == :integer && !valid_integer?(atts[k.to_sym])
                log "Invalid integer #{atts[k.to_sym]} in #{row.join(",")}"
                n_errors = n_errors + 1
                next
              end
              if class_name.columns_hash[k.to_sym].type == :datetime && !valid_datetime?(atts[k.to_sym])
                log "Invalid datetime #{atts[k.to_sym]} in #{row.join(",")}"
                n_errors = n_errors + 1
                next
              end
              if class_name.columns_hash[k.to_sym].type == :date && !valid_datetime?(atts[k.to_sym])
                log "Invalid date #{atts[k.to_sym]} in #{row.join(",")}"
                n_errors = n_errors + 1
                next
              end
            end
          end

          records << class_name.new(atts)

          if records.size >= batch_size
            success = false
            begin
              class_name.import records
              log "Imported #{records.size} records."
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
            log "Imported #{records.size} records."
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

        log "#{n_errors} errors" if n_errors > 0
        log "Finished importing."

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

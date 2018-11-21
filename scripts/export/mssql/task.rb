require "csv"

module Export
  module Mssql

    class Task

      attr_accessor :mssql_main, :task_file, :sequence
      def initialize(mssql_main, task_file)
        @mssql_main, @task_file = mssql_main, task_file
      end

      def global_config
        mssql_main.global_config
      end

      def task_config
        return @task_config unless @task_config.blank?
        @task_config = global_config.merge(YAML.load_file(task_file))
      end

      def import_model_name
        "Import::#{task_config['target_model']}".gsub(/::/, '')
      end

      def import_model
        return import_model_name.constantize if (import_model_name.constantize rescue nil)
        klass = Object.const_set(import_model_name, Class.new(ActiveRecord::Base))
        klass.table_name = task_config['source_table']
        klass.establish_connection mssql_main.db_opts
        klass.primary_key = nil
        # TODO handle multiple source_tables / break them into joins
        klass
      end

      def data
        scope = import_model
        scope = scope.distinct if task_config['select_distinct']
        scope
      end

      def export
        csv_file_path = File.join(global_config["export_folder"], "#{task_config["source_table"].downcase}.csv")

        CSV.open(csv_file_path, "wb") do |csv|
          csv << column_mappings.map{|k,v| v}

          data.each do |obj|
            csv << column_mappings.map{|k, v| obj.send(k) }
          end
        end # CSV.open
      end

      def column_mappings
        task_config['column_mappings']
      end

    end # class Task

  end
end

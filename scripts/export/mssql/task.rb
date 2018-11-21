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
        scope = import_model.select(select_clause)
        scope = scope.distinct if task_config['select_distinct']
        join_tables.each do |join_table|
          scope = scope.joins(join_table)
        end
        filters.each do |filter|
          scope = scope.where(filter)
        end
        if group_by_columns.present?
          scope = scope.group(group_by_columns)
        end
        scope
      end

      def join_tables
        task_config["join_tables"] || []
      end

      def group_by_columns
        task_config["group_by_columns"] || []
      end

      def filters
        if task_config["filters"].present?
          return task_config["filters"]
        elsif task_config["filter_raw"].present?
          return [task_config["filter_raw"]]
        end
        []
      end

      def select_clause
        column_mappings.each.map{ |k, v| "#{k} AS #{v}" }.join(", ")
      end

      def export
        csv_file_path = File.join(global_config["export_folder"], "#{task_config["source_table"].downcase}.csv")

        CSV.open(csv_file_path, "wb") do |csv|
          csv << column_mappings.map{|k,v| v}

          data.each_with_index do |obj, i|
            csv << column_mappings.each_with_index.map { |(k, v), i| obj.send(v) }
            puts "Processed #{i} records" if i > 0 && i % 10000 == 0
          end

        end # CSV.open
      end

      def column_mappings
        task_config['column_mappings']
      end

    end # class Task

  end
end

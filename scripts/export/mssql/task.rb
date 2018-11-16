module Export
  module Mssql

    class Task

      attr_accessor :mssql_helper, :task_file, :sequence
      def initialize(mssql_helper, task_file)
        @mssql_helper, @task_file = mssql_helper, task_file
      end

      def global_config
        mssql_helper.global_config
      end

      def task_config
        return @task_config unless @task_config.nil?
        @task_config = global_config.merge(YAML.load_file(task_file))
      end

      def import_model_name
        "Import::#{task_config['target_model']}".gsub(/::/, '')
      end

      def import_model
        return import_model_name.constantize if (import_model_name.constantize rescue nil)
        klass = Object.const_set(import_model_name, Class.new(ActiveRecord::Base))
        klass.table_name = task_config['source_tables']
        klass.establish_connection mssql_helper.db_opts
        # TODO handle multiple source_tables / break them into joins
        klass
      end

      def scope
        scope = import_model.select(select_clause)
        scope = scope.distinct if task_config['select_distinct']
        scope
      end

      def sql
        scope.to_sql
      end


      def column_mappings   
        task_config['column_mappings']
      end

      def select_clause
        select_clause = column_mappings.map{|k,v| "#{quoted_column_name(k)} AS #{v}"}.join(", ")
        # TODO SQLServer uses DISTINCT TOP 10. Can we use activerecord's .distinct intelligently?
        # select_clause = "DISTINCT #{select_clause}" if task_config['select_distinct']

        select_clause
      end

      def institution_id
        institution_id = Institution.get_id_from_code(task_config["institution_code"])
      end

      # protected
      def quoted_column_name(column_name)
        import_model.connection.quote_column_name column_name
      end

      def export_table_to_csv
        target_model = task_config["target_model"]
        filter = task_config["filter"]
        distinct = task_config["select_distinct"]
        select_sql = task_config["select_sql"]
        source_tables = task_config["source_tables"]
        unique_column = task_config["unique_column"]
        group_by_sql = task_config["group_by_sql"]
        column_mappings = task_config["column_mappings"] || {}
        fetch_rows_size = task_config["fetch_rows_size"] || 0

        column_mappings = {} unless column_mappings.is_a?(Hash)
        fetch_rows_size = fetch_rows_size.to_i

        do_paging = fetch_rows_size > 0 && unique_column.present?

        log "Started exporting #{target_model} into #{csv_file_path}"

        if test_mode
          fetch_rows_size = 100
          do_paging = true
        end

        if do_paging && unique_column.present?
          sql =  " SELECT #{distinct ? "DISTINCT" : ""} TOP #{fetch_rows_size} " + select_sql + ", (#{unique_column}) AS unique_column_val " +
                 " FROM " + source_tables +
                 " WHERE 1=1 "
          sql += "   AND (#{filter}) " if filter.present?
          if group_by_sql.present?
            sql += " GROUP BY " + group_by_sql + ", (#{unique_column}) "
          end
          sql += " ORDER BY #{ unique_column } ASC "
        else
          sql =  " SELECT #{distinct ? "DISTINCT" : ""} #{test_mode ? "TOP #{fetch_rows_size}" : ""} " + select_sql +
                 " FROM " + source_tables +
                 " WHERE 1=1 "
          sql += " AND (#{filter}) " if filter.present?
          sql += " GROUP BY " + group_by_sql if group_by_sql.present?
        end
        sql.gsub!("\n", " ")

        require "csv"

        CSV.open(csv_file_path, "wb") do |csv|
          log "Executing query: #{sql}"
          row_results = db.execute( sql )
          if row_results.count > 0
            csv << row_results.first.except("unique_column_val").keys.map { |x| column_mappings[x].present? ? column_mappings[x] : x }
          end
          last_unique_column_val = ""

          done = false
          while !done
            row_results.each do |row|
              csv << row.except("unique_column_val").values
              last_unique_column_val = row["unique_column_val"]
            end

            if do_paging && last_unique_column_val.present?
              sql = "  SELECT TOP #{fetch_rows_size} " + select_sql + ", (#{unique_column}) AS unique_column_val " +
                    "  FROM " + source_tables +
                    "  WHERE 1=1 "
              sql += "   AND (#{filter}) " if filter.present?
              sql += "   AND (#{unique_column}) > '#{last_unique_column_val.to_s.gsub("'", "''")}' "
              if group_by_sql.present?
                sql += " GROUP BY " + group_by_sql + ", (#{unique_column}) "
              end
              sql += " ORDER BY #{ unique_column } ASC "
              sql.gsub!("\n", " ")
              row_results = db.execute( sql )
              last_unique_column_val = ""
            else
              done = true
            end

            done = true if test_mode
          end # while !done

        end # CSV.open
        db.close
        log "Finished exporting #{target_model} into #{csv_file_path}"
      end

    end

  end
end

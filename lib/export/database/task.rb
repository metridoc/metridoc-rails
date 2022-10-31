module Export
  class Database::Task < Task

    # Make a name for the ActiveRecord model of the source table
    # Eg. the source model for the destination model Some::Model
    # will be Import::Some::Model
    def import_model_name
      "Import::#{task_config['target_model']}".gsub(/::/, '')
    end

    # Specify the source adapter engine depending on the input adapter
    def source_adapter_engine
      source_adapter == "postgres" ? "postgresql" : "sqlserver"
    end

    # Create an ActiveRecord model for the source table
    def import_model
      # If the model is already made, return it.
      return import_model_name.constantize if (import_model_name.constantize rescue nil)
      # Build a new model object for the source
      klass = Object.const_set(import_model_name, Class.new(ActiveRecord::Base))
      # Get the source table name
      klass.table_name = task_config['source_table']
      # Setup a connection to the source
      klass.establish_connection @main_driver.global_config.merge(
        adapter: source_adapter_engine
      )
      klass.primary_key = nil
      # TODO handle multiple source_tables / break them into joins
      # Return the source model
      klass
    end

    # Returns the target model as an object
    def target_model
      @target_model ||= task_config["target_model"].constantize
    end

    # Get string to filter since minimum date
    def export_filter_date_sql
      task_config["export_filter_date_sql"]
    end

    # Get string to filter between two dates
    def export_filter_date_range_sql
      task_config["export_filter_date_range_sql"]
    end

    # The column to use for incremental updates
    # Typically a date
    def incremental_filter_column
      task_config["incremental_filter_column"]
    end

    # Get any other filters to add to the query
    def filters
      if task_config["filters"].present?
        return task_config["filters"]
      elsif task_config["filter_raw"].present?
        return [task_config["filter_raw"]]
      end
      []
    end

    # The minimum date for the query to retrieve
    def from_date
      @from_date ||= Date.parse(task_config["from_date"]) rescue nil
    end

    # The maximum date for the query to retrieve
    def to_date
      @to_date ||= Date.parse(task_config["to_date"]) rescue nil
    end

    # Construct a list of statements to select specified columns
    def select_clause
      column_mappings.each.map{ |k, v| "#{k} AS #{v}" }.join(", ")
    end

    # String containing a raw query to execute
    def from_raw
      task_config["from_raw"]
    end

    # List of tables to join in the query
    def join_tables
      task_config["join_tables"] || []
    end

    # List of columns to group by in the query
    def group_by_columns
      task_config["group_by_columns"] || []
    end

    # Prepares the query for the export of source data
    def data
      # Build the Select statement
      scope = import_model.select(select_clause)

      # Add a distinct clause if required
      scope = scope.distinct if task_config['select_distinct']

      # Add the raw sql clause
      scope = scope.from(from_raw) if from_raw.present?

      # Join tables listed in configuration
      join_tables.each do |join_table|
        scope = scope.joins(join_table)
      end

      # Filter non-datetime columns
      filters.each do |filter|
        scope = scope.where(filter)
      end

      # Select records with dates bigger than a minimum
      if export_filter_date_sql.present?
        if incremental_filter_column
          # Find the latest date in the specified column for incremental loading
          latest_date = target_model.pluck(
            " MAX(#{ActiveRecord::Base.connection.quote_column_name(
            incremental_filter_column
            )}) AS latest_date"
          ).first
          # Add the filter to the query
          scope = scope.where(export_filter_date_sql, latest_date) if latest_date
        end
      end

      # Add a date range filter to the query
      # Default range is from one year ago to yesterday
      if export_filter_date_range_sql.present?
        scope = scope.where(
          export_filter_date_range_sql,
          from_date || Date.today - 1.years,
          to_date || Date.yesterday
        )
      end

      # Group by columns listed in configuration
      if group_by_columns.present?
        scope = scope.group(group_by_columns)
      end

      # Return the prepared query
      scope
    end

    # Execute the export step for this task
    def execute
      log_job_execution_step

      # Make an export folder if it doesn't already exist
      FileUtils.mkdir_p task_config["export_folder"]

      # Create a new csv filename for the data
      csv_file_path = File.join(
        task_config["export_folder"],
        task_config["export_file_name"].downcase
      )

      # Open the output csv file and write to it
      CSV.open(csv_file_path, "wb") do |csv|

        # Insert the column headers into the CSV
        csv << column_mappings.map{|k,v| v}

        # Prepare the database query
        db = data

        # Run the database query
        response = db.connection.query(db.to_sql)

        # Only write the first 100 rows to the csv for the test mode
        if test_mode?
          response[0...100].each { |r| csv << r }
        else
          # Write rows in batches of 10,000 to the csv
          response.each_slice(10000) {|rows| rows.each {|r| csv << r} }
        end

      end # CSV.open

      # Mark the Step as successful
      log_job_execution_step.set_status!("successful")
      return true

    rescue => ex
      # In case of an error, mark the job as unsuccessful
      log "Error => [#{ex.message}]"
      log_job_execution_step.set_status!("failed")
      return false
    end

  end
end

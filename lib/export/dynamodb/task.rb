module Export
  class Dynamodb::Task < Task
    attr_reader :table, :records

    # Initialize the connection to the AWS database and prepare output
    def connect
      client = Aws::DynamoDB::Client.new(
        region: task_config["aws_region"], 
        profile: task_config["aws_profile"]
      )

      dynamo_resource = Aws::DynamoDB::Resource.new(client: client)
      @table = dynamo_resource.table(task_config["source_table"])

      # Initialize the empty array for the output records
      @records = []

    end

    # TODO: This should be refactored to a yaml reader class.
    def incremental_filter
      return @incremental_filter if @incremental_filter.present?

      # Set a default start date for the incremental filter
      @incremental_filter = "2025-01-01"

      # If the task config is missing the column to filter on return the default
      unless task_config["incremental_filter_column"].present?
        return @incremental_filter
      end

      # If the model has no entries, return the default filter
      unless target_model.any?
        return @incremental_filter
      end

      # Find the latest date in the specified column for incremental loading
      @incremental_filter = target_model.maximum(
        task_config["incremental_filter_column"]
      ).strftime("%Y-%m-%d")
    end

    # Insert attribute values from yaml
    # But also want incremental loading.
    # Function builds the parameters for the query.
    # This is passed as a hash object.
    def build_scan_hash(start_key: nil)
      {
        filter_expression: task_config["input_filter_name"] + " >= :dt",
        expression_attribute_values: {
          ":dt" => incremental_filter
        },
        return_consumed_capacity: "TOTAL",
        exclusive_start_key: start_key
      }
    end

    # Function takes the response data and builds
    # a Query object
    def save_query_data(input)
      StreamDeck::ServicePoint::Query.create(
        :count => input.count,
        :scanned_count => input.scanned_count,
        :capacity_units => input.consumed_capacity.capacity_units,
        :downloaded_at => Time.now()
      )
    end

    # Function runs a scan on the table.
    # Returns the start_key for the next query.
    def scan_items(start_key: nil)
      response = @table.scan(
        build_scan_hash(start_key: start_key)
      )

      # Save the query data
      save_query_data(response)

      # Add response items to records
      @records.concat(response.items) unless response.items.empty?

      # Return the last_evaluated_key to use as a start_key for the next call
      response.last_evaluated_key

    rescue Aws::DynamoDB::Errors::ServiceError => e
      log "Error in data collection:"
      log "\t#{e.code}: #{e.message}"
      raise
    end

    def write_csv(data)
      # Write the data to a csv file
      CSV.open(csv_file_path, 'w') do |csv|
        # Write the headers
        csv << data.first.keys.map{ |column_name|
          task_config["column_mappings"].fetch(column_name, column_name)
      }.append("downloaded_at")
        # Add each row by row
        data.each do |hash|
          csv << hash.values.append(Time.now())
        end
      end
    end

    # Execute the export step for this task
    def execute
      log_job_execution_step

      # Make an export folder if it doesn't already exist
      FileUtils.mkdir_p task_config["export_folder"]

      # Connect to AWS
      connect

      # Evaluate scan_items until no more items are needed
      next_key = scan_items
      until next_key.nil?
        next_key = scan_items(start_key: next_key)
      end
      write_csv(@records)

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
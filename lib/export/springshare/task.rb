module Export
  class Springshare::Task < Task

    # Function to find the starting point for the incremental filter
    def incremental_filter
      return @incremental_filter if @incremental_filter.present?

      # Find the latest date in the specified column for incremental loading
      @incremental_filter = target_model.maximum(
        task_config["incremental_filter_column"]
      ).strftime("%Y-%m-%d") rescue nil
    end

    # Fetch the column name for a download timestamp column
    def download_timestamp
      @download_timestamp ||= task_config["download_timestamp"]
    end

    # Function to get the date of the most recent download
    def last_download
      return @last_download if @last_download.present?

      # Find the most recent download time
      @last_download = target_model.maximum(
        download_timestamp
      ).strftime("%Y-%m-%d") rescue nil
    end

    # Fetch any parameters for the API call
    def parameters
      @parameters ||= task_config["parameters"]
    end

    # Get any json column definitions
    def json_column
      @json_column ||= task_config["json_column"]
    end

    # Get any merged column definitions
    def merge_columns
      @merge_columns ||= task_config["merge_columns"]
    end

    # Get any merged column definitions
    # The yaml string needs to be "eval"ed in order to create the regex string
    def merge_columns_regex
      @merge_columns_regex ||= eval task_config["merge_columns_regex"]
    end

    # Function to fetch an authorization token from Springshare
    def fetch_token
      # Authorization URL
      uri = URI(task_config['auth']['domain'])

      # Create the Token request
      client = OAuth2::Client.new(
        task_config['auth']['client_id'],
        task_config['auth']['client_secret'],
        site: uri.scheme + '://' + uri.hostname,
        token_url: uri.path
      )

      # Check the grant type
      if task_config['auth']['grant_type'] == "client_credentials"
        # Save the token
        @token = client.client_credentials.get_token
      else
        raise "Springshare: Unknown Credential Type"
      end

      # Ensure successful response
      if @token.response.status.to_s != "200"
        raise "Bad Status: " + @token.response.status
      end

      # Save the expiry time to the class
      @expiry_time = Time.at(@token.expires_at)
    end # End of authorization

    def fetch_response
      response = @token.get(
        @report_url,
        params: parameters || nil
      )

      # Extract the JSON document returned
      JSON.parse(response.body)
    end

    # Connect to the API and get documents
    def connect
      # Refresh the token if needed
      if Time.now > @expiry_time
        @token.refresh!
        # Update the expiry time
        @expiry_time = Time.at(@token.expires_at)
      end

      # Start the date range from either the last_download or
      # from the most recent uploaded fromDate value.
      start_date = [incremental_filter, last_download].compact.min
      parameters.merge!("date": start_date) if start_date.present?

      # Specify the report url
      @report_url = task_config["report_path"]

      # Some instances require identifiers appended to query
      if task_config["filter_ids"].present?
        ids_list = ActiveRecord::Base.connection.execute(
          task_config["filter_ids"]
        )
        @report_url += "/" + ids_list.values.join(",")
      end

      # If pagination isn't needed
      unless parameters["page"] && parameters["limit"]
          @document = fetch_response
          return
      end

      # To retrieve multiple pages
      @document = []
      # Keep the individual page separate
      page_response = []
      while parameters["page"] == 1 || page_response.length == parameters["limit"]
        page_response = fetch_response
        @document += page_response

        # Increment the page number passed to parameters
        parameters["page"] += 1
      end
    end

    # Write the header of the CSV file
    def write_column_headers
      # Extract the list of headers the document
      # This gets all the keys of each record and then builds a unique list
      @headers = @document.map(&:keys).inject(&:|)

      # Add a column for any merged columns and remove the columns that are
      # going to be merged
      if merge_columns.present? and merge_columns_regex.present?
        @headers << merge_columns if merge_columns.present?
        @headers.delete_if{
          |value| value.to_s.match?(merge_columns_regex)
        }
      end

      # Add a column to record the downloaded timestamp
      @headers << download_timestamp if download_timestamp.present?

      # Create a new CSV file and write the headers
      CSV.open(csv_file_path, 'w') do |csv|
        csv << @headers.map{|v| column_mappings[v] || v}
      end
    end

    # Write the data in batches to file
    def write_batch_data
      # Open the CSV file to append to it
      CSV.open(csv_file_path, 'a', headers: @headers) do |csv|
        # Get the current time
        current_time = Time.now

        # Loop through each entry of the return document
        @document.each do |h|
          # Check if all keys are in h
          missing_keys = @headers - h.keys
          # Add any missing elements to h as a nil value
          missing_keys.each{|k| h[k] = nil}

          # Merge multiple columns into a single JSON object by the regex rule
          if merge_columns.present? and merge_columns_regex.present?
            # Select the parts of the hash that match a particular regex string
            # and save the value as a json string

            merged = h.select {
              |key, value| key.to_s.match?(merge_columns_regex)
            }

            # Return a nil value for empty merged columns
            h[merge_columns] = merged.empty? ? nil.to_json : merged.to_json
          end

          # Convert json column to a json string if present
          if json_column.present?
            #h[json_column] = h[json_column].nil? ? '[]' : h[json_column].to_json
            h[json_column] = h[json_column].to_json
          end

          # Add the current time to the record if there is
          # a download timestamp column
          if download_timestamp.present?
            h[download_timestamp] = current_time
          end

          # Add to the csv, maintaining the same order as the header
          csv << @headers.map{|header| h.fetch(header, nil)}
        end
      end
    end

    # Execute the export step for this task
    def execute
      log_job_execution_step

      # Make an export folder if it doesn't already exist
      FileUtils.mkdir_p task_config["export_folder"]

      # Create an authorization token
      fetch_token

      # Connect and fetch a document
      connect

      # Write the document to file
      write_column_headers
      write_batch_data

      # Mark the Step as successful
      log_job_execution_step.set_status!("successful")
      return true

    rescue => ex
      # In case of an error, mark the job as unsuccessful
      log "Error => [#{ex.message}]"
      log_job_execution_step.set_status!("failed")
      return false
    end # End Execution
  end
end

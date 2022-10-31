module Export
  class Alma::Task < Task

    # Build the url to connect with the API
    def url(token = "")
      url = task_config['alma_domain'] + task_config['report_path']

      # Add the api key to the url
      url += task_config["apikey_string"] + task_config["alma_apikey"]

      # Add a requests limit
      url += task_config["limit"]

      # Add the token
      unless token.empty?
        url += token
      end

      return url
    end

    # Build a CSV file path to store the exported information
    def csv_file_path
      @csv_file_path ||= File.join(
        task_config["export_folder"],
        task_config["file_name"].downcase
      )
    end

    # Connect and retrieve the information from the api endpoint
    def connect(report_path = "")
      response = nil

      # Open a connection to the url
      URI.open(url(report_path)) do |f|
        # Query the status of the API Call
        status = f.status[0]

        # Only allow successful API Calls
        if status != "200"
          raise "Bad Status: " + status
        end

        # Read the document into the response
        response = f.read
      end

      # Parse the result with Nokogiri
      @document = Nokogiri::XML(response)

      # Remove namespaces before parsing
      @document.remove_namespaces!

      # Pull out the resumption token and the indicator for last page
      resumption_token = @document.xpath('//ResumptionToken').first.content rescue ""
      is_finished = @document.xpath('//IsFinished').first.content rescue ""

      # Return the token value and the finished flag
      {
        token: resumption_token,
        is_finished: is_finished
      }
    end

    # This function extracts the column headers and writes them to the output file
    def write_column_headers

      # Get the column headings
      @column_names = {}
      # Access the schema
      @document.xpath('//element').each do |elem|
        # Extract the column name and the column heading
        column = elem.attributes["name"].value
        column_name = elem.attributes["columnHeading"].value

        # Get the output csv header name
        # If the column has no equivalent, just use the current heading
        output_column_name = column_mappings[column_name] || column_name

        # Make a column mapping
        @column_names[column] = output_column_name
      end

      # Add the headers to the csv file
      CSV.open(csv_file_path, 'w') do |csv|
        csv << @column_names.values
      end

    end

    # Function will loop through xml data and write it to a CSV file
    def write_batch_data
      data = []
      # Loop through each row of data
      @document.xpath('//Row').each do |xml_row|
        row = []
        # Loop through each column value
        @column_names.keys.each do |column|
          row.append(xml_row.xpath(column).text)
        end
        data.append(row)
      end

      # Write the data to a csv file
      CSV.open(csv_file_path, 'a') do |csv|
        # Add each row by row
        data.each do |row|
          csv << row
        end
      end
    end

    # Connect to the API and save the report to a CSV
    def save_report

      # Parse the result with Nokogiri
      response = connect

      # Add the column headers to the file
      write_column_headers

      # Append the first batch of data to the file
      write_batch_data

      # Save the token for successive calls
      token = "&token=" + response[:token] || ""

      # Loop until the end of the query
      until response[:is_finished] === "true"
        response = connect(token)
        write_batch_data
      end

    end

    # Execute the export step for this task
    def execute
      log_job_execution_step

      # Make an export folder if it doesn't already exist
      FileUtils.mkdir_p task_config["export_folder"]

      save_report

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

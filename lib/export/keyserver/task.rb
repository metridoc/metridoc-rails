module Export
  class Keyserver::Task < Task
    def access_token
      @access_token ||= task_config['access_token']
    end

    def request_headers
      @request_headers ||= {
        "Authorization" => "Bearer #{access_token}",
        "Accept" => "application/json",
        "Content-Type" => "application/json"
      }
    end

    def parameters
      @parameters ||= task_config["parameters"]
    end

    def endpoint
      @endpoint ||= task_config["keyreporter_url"] + task_config["report_path"]
    end

    def get_reports
      report_name = task_config["report_name"]
      return nil unless report_name
      ::Keyserver::Report.where(name: report_name, downloaded: nil).pluck(:ident)
    end

    def mark_reports_downloaded
      return if @downloaded_reports.blank?
      ::Keyserver::Report
        .where(ident: @downloaded_reports)
        .update_all(downloaded: Time.current)
    end
    
    def fetch_response(api_endpoint = endpoint)
      begin
        connection = Faraday.new do |f|
          f.options.timeout = 10
          f.options.open_timeout = 10
        end

        response = connection.get(api_endpoint, parameters, request_headers)

        if response.success?
          return JSON.parse(response.body)
        else
          case response.status
            when 401 then raise "Invalid Access Token"
            when 403 then raise "Access denied"
            when 404 then raise "Invalid enpoint"
          end
        end
      rescue Faraday::TimeoutError, Faraday::ConnectionFailed => err
        log "Network Error: #{err.message}"
      rescue JSON::ParserError => err
        log "JSON Error: #{err.message}"
      rescue StandardError => err
        log "Error: #{err.message}"
      end
    end

    def connect
      reports = get_reports()

      @document = []
      @downloaded_reports = []

      if reports.nil?
        @document = fetch_response
      elsif reports.blank?
        log "No reports found"
      else
        reports.each do |report_id|
          report_endpoint = endpoint % {report_id: report_id}
          data = fetch_response(report_endpoint)
          next if data.nil?

          @document += data
          @downloaded_reports << report_id
        end
      end
    end

    # Write the header of the CSV file
    def write_column_headers
      # Extract the list of headers the document
      # This gets all the keys of each record and then builds a unique list
      @headers = @document.map(&:keys).inject(&:|)

      # Create a new CSV file and write the headers
      CSV.open(csv_file_path, 'w') do |csv|
        csv << @headers.map{|v| column_mappings[v] || v}
      end
    end


    # Write the data in batches to file
    def write_batch_data
      # Open the CSV file to append to it
      CSV.open(csv_file_path, 'a', headers: @headers) do |csv|

        # Loop through each entry of the return document
        @document.each do |h|
          # Check if all keys are in h
          missing_keys = @headers - h.keys
          # Add any missing elements to h as a nil value
          missing_keys.each{|k| h[k] = nil}

          # Add to the csv, maintaining the same order as the header
          csv << @headers.map{|header| h.fetch(header, nil)}
        end
      end
    end

    def execute
      log_job_execution_step

      FileUtils.mkdir_p task_config["export_folder"]
      connect

      # Write to file
      unless @document.blank?
        write_column_headers
        write_batch_data
        mark_reports_downloaded
      end

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

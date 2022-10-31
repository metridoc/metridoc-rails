# frozen_string_literal: true

require 'fileutils'
require 'net/sftp'
module Export
  # Attempt 3 connections to the SFTP before failing the job
  MAX_CONNECTION_ATTEMPTS = 3
  # sleep for 10 minutes between failed connection attempts
  SLEEP_INTERVAL = 10 * 60

  class Sftp::Task < Task

    # Construct a date stamped filename for the downloaded file
    # This is file is archived
    def export_file_path
      require 'date'
      today = Date.today.to_s
      fname = today + '_' + File.split(task_config['source_path'])[1]
      # Use standard temp dir
      File.join(Dir.tmpdir, fname)
    end

    # Construct a file name for the temporary file that is processed and
    # ingested into MetriDoc
    def import_file_path
      File.join(task_config['import_folder'], task_config['file_name'])
    end

    # Function connects and downloads the file via sftp
    def sftp_file
      log "Downloading SFTP data [#{task_config['host']}]"

      begin
        Net::SSH.start(
          task_config['host'],
          task_config['username'],
          :password => task_config['password'],
          :compression => 'none'
        ) do |ssh|
          # Download the file from the source path into the export file path
          ssh.sftp.download!(task_config['source_path'], export_file_path)
        end

      rescue SocketError => e
        # Catch socket (communication errors)
        # Sleep before retrying
        log "SSH connection error ... retrying in #{SLEEP_INTERVAL / 60} minutes."
        sleep SLEEP_INTERVAL
        sleep 1
        # Retry and count attempts
        retry if attempts = (attempts || 0) + 1 and attempts <= MAX_CONNECTION_ATTEMPTS

        # Stop after maximum attempts
        log "Maximum connection attempts (#{MAX_CONNECTION_ATTEMPTS}) met. Giving up. Error: [#{e}]"
        raise "Maximum connection attempts met."

      rescue => ex
        # Catch generic errors
        log "Encountered SSH connection error: #{ex.message}"
        raise "Encountered SSH connection error."
      end
    end

    # Execute the export step for this task
    def execute
      log_job_execution_step

      # Download the file from the SFTP
      sftp_file

      # Make an export folder if it doesn't already exist
      FileUtils.mkdir_p task_config["import_folder"]

      # Remove previous file if exists
      FileUtils.remove_file(import_file_path, :force => true)

      # Move the date stamped file to a shared docker drive
      # for further processing
      log "Copying #{export_file_path} to #{import_file_path}"
      FileUtils.copy(export_file_path, import_file_path)

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

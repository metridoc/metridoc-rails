module Export
  class Export

    # Load all the task classes
    require 'export/alma/task.rb'
    require 'export/database/task.rb'
    require 'export/sftp/task.rb'

    # Setup the export options
    def initialize(options = {})
      # Copy options into the class variable
      @options = options

      # Load environment variables
      require 'dotenv'
      Dotenv.load(File.join(root_path, ".env"))

      # Check for a configuration folder
      raise "Config Folder not specified." if config_folder.blank?
      raise "Config Folder [#{config_folder}] doesn't exist." unless Dir.exist?(
        File.join(root_path, "config", "data_sources", config_folder)
      )
    end

    # Pull the configuration folder from the options hash
    def config_folder
      @config_folder ||= @options[:config_folder]
    end

    # Find the root path of the package
    def root_path
      @root_path ||= File.expand_path('../../', File.dirname(__FILE__))
    end

    # Check if test mode is set to true
    def test_mode?
      @test_mode ||= @options[:test_mode].upcase.strip == "TRUE" rescue false
    end

    # Select the task class depending on the specified source adapter
    def task(source_adapter, task_file)
      case source_adapter
      when "sftp"
        Sftp::Task.new(self, task_file)
      when "postgres"
        Database::Task.new(self, task_file)
      when "mysql"
        Database::Task.new(self, task_file)
      when "alma"
        Alma::Task.new(self, task_file)
      else
        nil
      end
    end

    # Make a list of task files to run
    def task_files(sequences_only = [])

      # Optional list of tasks to filter for
      sequences_only = [sequences_only] if sequences_only.present? && !sequences_only.is_a?(Array)

      # List of all files in the configuration folder
      full_paths = Dir[
        File.join(root_path, "config", "data_sources", config_folder, "**", "*")
      ]

      tasks = []
      # Loop through each path
      full_paths.each do |full_path|
        # Skip if the file is not a yml file
        next if File.extname(full_path) != '.yml'
        # Skip if the file is the global yml file
        next if File.basename(full_path) == "global.yml"

        # Load the yaml file
        table_params = YAML.load_file(full_path)
        # Get the sequence of the file
        seq = table_params["load_sequence"] || 0
        # Get the source adapter of the file
        source_adapter = table_params["source_adapter"] || ""

        # Skip if this yml is not in the filtered list of sequences (if present)
        next if sequences_only.present? && !sequences_only.include?(seq)

        # Add the sequence number and the path to the file to the tasks list
        tasks << {
          load_sequence: seq,
          full_path: full_path,
          source_adapter: source_adapter
        }
      end

      # Return a sorted (by sequence number) list of full yml paths
      tasks.sort_by{
        |t| t[:load_sequence]
      }.map{
        |t| [t[:full_path], t[:source_adapter]]
      }
    end

    # Execute the tasks
    def execute(sequences_only = [])
      @log_job_execution = log_job_execution

      # Loop through the task files
      task_files(sequences_only).each do |task_file, source_adapter|

        # Create a new Task
        t = task(source_adapter, task_file)

        # Skip this file if no Task was created
        next if t.nil?

        # Log the start of a step
        log("Started executing step [#{task_file}]")

        # Log a failed step
        unless t.execute
          log("Failed executing step [#{task_file}]")
          log_job_execution.set_status!('failed')
          return false
        end

        # Log the end of the step
        log("Ended executing step [#{task_file}]")
      end

      # Set the step as successful
      log_job_execution.set_status!('successful')
      return true
    end

    # Load the Global Configuration File
    def global_config
      return @global_params unless @global_params.blank?

      global_params = {}

      # Build the global parameter file name
      yml_path = File.join(root_path, "config", "data_sources", config_folder, "global.yml")

      # If the file exists, load the file into a hash
      if File.exist?(yml_path)
        global_params = YAML.load(ERB.new(File.read(yml_path)).result)
      end

      # Merge the global configuration with the options
      @global_params = global_params.merge(@options.stringify_keys)
    end

    # Create a log job execution entry
    def log_job_execution
      return @log_job_execution if @log_job_execution.present?

      # Access the environment configuration
      environment = ENV['RACK_ENV'] || ENV['RAILS_ENV'] || 'development'
      dbconfig = YAML.load(
        File.read(
          File.join(root_path, 'config', 'database.yml')
        )
      )

      # Connect to the database
      Log::JobExecution.establish_connection dbconfig[environment]

      # Create a Log::JobExecution entry
      @log_job_execution = Log::JobExecution.create!(
        source_name: config_folder,
        job_type: 'export',
        global_yml: global_config,
        mac_address: ApplicationHelper.mac_address,
        started_at: Time.now,
        status: 'running'
      )
    end

    # Add new log information to the Log::JobExecution Entry
    def log(m)
      # Create the log line with a message
      log = "#{Time.now} - #{m}"
      # Add the log line to the database
      log_job_execution.log_line(log)
      # Print the log to the std out
      puts log
    end

  end
end

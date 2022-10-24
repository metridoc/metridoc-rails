module Export
  class Task

    # Initialize the Task with the Main object
    # and a yaml configuration file
    def initialize(main_driver, task_file)
      @main_driver, @task_file = main_driver, task_file
    end

    # Open the global configuration file
    # Merge the global configuration information with the
    # task file information and save to @task_config
    def task_config
      @task_config ||= @main_driver.global_config.merge(
        YAML.load(
          ERB.new(
            File.read(@task_file)
          ).result
        )
      )
    end

    # Check if the Main Object is in Test Mode
    def test_mode?
      @main_driver.test_mode?
    end

    # Access the source adapter from the task configuration
    def source_adapter
      @source_adapter ||= task_config["source_adapter"]
    end

    # Create a log job execution step entry
    def log_job_execution_step
      return @log_job_execution_step if @log_job_execution_step.present?

      # Access the environment configuration
      environment = ENV['RACK_ENV'] || ENV['RAILS_ENV'] || 'development'
      dbconfig = YAML.load(
        File.read(
          File.join(
            @main_driver.root_path, 'config', 'database.yml'
          )
        )
      )

      # Connect to the database
      Log::JobExecutionStep.establish_connection dbconfig[environment]

      # Create a Log::JobExecutionStep Entry
      @log_job_execution_step = Log::JobExecutionStep.create!(
        job_execution_id: @main_driver.log_job_execution.id,
        step_name: task_config["load_sequence"],
        step_yml: task_config,
        started_at: Time.now,
        status: 'running'
      )
    end

    # Add a new log information to the Log::JobExecutionStep Entry
    def log(m)
      # Create a log line with a message
      log = "#{Time.now} - #{m}"
      # Add the log line to the database
      log_job_execution_step.log_line(log)
      # Print the log line to std out
      puts log
    end

  end
end

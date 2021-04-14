# frozen_string_literal: true

require 'fileutils'
require 'net/sftp'
module Export
  module Sftp
    MAX_CONNECTION_ATTEMPTS = 3
    # sleep for 10 minutes between failed connection attempts
    SLEEP_INTERVAL = 10 * 60

    class Task
      def initialize(main_driver, task_file)
        @main_driver, @task_file = main_driver, task_file
      end

      def task_config
        return @task_config unless @task_config.blank?

        @task_config = @main_driver.global_config.merge(YAML.load(ERB.new(File.read(@task_file)).result))
      end

      def check_dir(path)
        unless Dir.exist?(path)
          log "Creating directory [#{path}]"
          begin
            Dir.mkdir(path)
            true
          rescue SystemCallError => e
            log "Couldn't create path [#{path}]: #{e.message}"
            false
          end
        end
        true
      end

      def export_file_path
        require 'date'
        today = Date.today.to_s
        fname = today + '_' + File.split(task_config['source_path'])[1]
        # use standard temp dir
        File.join(Dir.tmpdir, fname)
      end

      def import_file_path
        File.join(task_config['import_folder'], task_config['file_name'])
      end

      def copy_to_preprocess_dir
        # create task_config['import_folder'] if it doesn't exist
        if File.exist?(import_file_path)
          # purge old file
          FileUtils.remove_file(import_file_path)
        end
        log "Copying #{export_file_path} to #{import_file_path}"
        begin
          FileUtils.copy(export_file_path, import_file_path)
          true
        rescue Errno::ENOENT => e
          log "Caught exception while attempting to copy #{export_file_path} to #{import_file_path}: [#{e}]"
          false
        end
      end

      def sftp_file
        log "Downloading GateCount data [#{task_config['host']}]"
        begin
          Net::SSH.start(task_config['host'], task_config['username'], :password => task_config['password'], :compression => 'none') do |ssh|
            ssh.sftp.download!(task_config['source_path'], export_file_path)
          end
          true
        rescue SocketError => e
          log "SSH connection error ... retrying in #{SLEEP_INTERVAL / 10} minutes."
          sleep SLEEP_INTERVAL
          sleep 1
          retry if attempts = (attempts || 0) + 1 and attempts <= MAX_CONNECTION_ATTEMPTS
          log "Maximum connection attempts (#{MAX_CONNECTION_ATTEMPTS}) met. Giving up. Error: [#{e}]"
          false
        rescue => someException
          log "Encountered SSH connection error: #{someException.message}"
        end
      end

      def execute
        log_job_execution_step

        result = sftp_file
        return unless result == true

        result = check_dir(task_config['import_folder'])
        return unless result

        copy_to_preprocess_dir
      end

      def source_adapter
        task_config["source_adapter"]
      end

      def test_mode?
        @main_driver.test_mode?
      end

      def log_job_execution_step
        return @log_job_execution_step if @log_job_execution_step.present?

        environment = ENV['RACK_ENV'] || ENV['RAILS_ENV'] || 'development'
        dbconfig = YAML.load(File.read(File.join(@main_driver.root_path, 'config', 'database.yml')))
        Log::JobExecutionStep.establish_connection dbconfig[environment]

        @log_job_execution_step = Log::JobExecutionStep.create!(
          job_execution_id: @main_driver.log_job_execution.id,
          step_name: task_config["load_sequence"],
          step_yml: task_config,
          started_at: Time.now,
          status: 'running'
        )
      end

      def log(m)
        log = "#{Time.now} - #{m}"
        log_job_execution_step.log_line(log)
        puts log
      end
    end
  end
end

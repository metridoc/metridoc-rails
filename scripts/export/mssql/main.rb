require '../../../app/models/log/job_execution.rb'
require '../../../app/helpers/application_helper.rb'

module Export
  module Mssql

    class Main
      def initialize(options = {})
        @options = options
        require 'dotenv'
        Dotenv.load(File.join(root_path, ".env"))

        raise "Config Folder not specified." if config_folder.blank?
        raise "Config Folder [#{config_folder}] doesn't exist." unless Dir.exist?(File.join(root_path, "config", "data_sources", config_folder))
      end

      def config_folder
        @options[:config_folder]
      end

      def root_path
        File.expand_path('../../..', File.dirname(__FILE__))
      end

      def test_mode?
        return @test_mode unless @test_mode.nil?
        @test_mode = @options[:test_mode].upcase.strip == "TRUE" rescue false
      end

      def execute(sequences_only = [])
        @log_job_execution = log_job_execution

        task_files(sequences_only).each do |task_file|
          t = Task.new(self, task_file)
          next unless t.source_adapter == 'mssql'
          log("Started executing step [#{task_file}]")
          unless t.execute
            log("Failed executing step [#{task_file}]")
            log_job_execution.set_status!('failed')
            return false
          end
          log("Ended executing step [#{task_file}]")
        end

        log_job_execution.set_status!('successful')
        return true
      end

      def task_files(sequences_only = [])
        sequences_only = [sequences_only] if sequences_only.present? && !sequences_only.is_a?(Array)

        full_paths = Dir[ File.join(root_path, "config", "data_sources", config_folder, "**", "*")]
        tasks = []
        full_paths.each do |full_path|
          next if File.basename(full_path) == "global.yml"

          table_params = Psych.safe_load_file(full_path)
          seq = table_params["load_sequence"] || 0

          next if sequences_only.present? && !sequences_only.include?(seq)

          tasks << {load_sequence: seq, full_path: full_path}
        end

        tasks.sort_by{|t| t[:load_sequence]}.map{|t| t[:full_path]}
      end

      def global_config
        return @global_params unless @global_params.blank?

        global_params = {}

        yml_path = File.join(root_path, "config", "data_sources", config_folder, "global.yml")

        if File.exist?(yml_path)
          global_params = Psych.safe_load(
            ERB.new(File.read(yml_path)).result,
            aliases: true
          )
        end

        @global_params = global_params.merge(@options.stringify_keys)
      end

      def db_opts
        opts = {    host:     global_config["host"],
                    port:     global_config["port"],
                    database: global_config["database"],
                    username: global_config["username"],
                    password: global_config["password"],
                    adapter:  'sqlserver',
                    pool:     5,
                    timeout:  120000 }
      end

      def log_job_execution
        return @log_job_execution if @log_job_execution.present?

        environment = ENV['RACK_ENV'] || ENV['RAILS_ENV'] || 'development'
        dbconfig = Psych.safe_load_file(
          File.join(root_path, 'config', 'database.yml'),
          aliases: true
        )

        Log::JobExecution.establish_connection dbconfig[environment]

        @log_job_execution = Log::JobExecution.create!(
                                                        source_name: config_folder,
                                                        job_type: 'export',
                                                        global_yml: global_config,
                                                        mac_address: ApplicationHelper.mac_address,
                                                        started_at: Time.now,
                                                        status: 'running'
                                                      )
      end

      def log(m)
        log = "#{Time.now} - #{m}"
        log_job_execution.log_line(log)
        puts log
      end

    end

  end
end

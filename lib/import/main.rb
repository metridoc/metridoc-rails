module Import

    class Main
      def initialize(options = {})
        @options = options

        require 'dotenv'
        Dotenv.load(File.join(root_path, ".env"))

        raise "Missing Data Source" if config_folder.blank?

        raise "Data Source [#{config_folder}] doesn't exist." unless DataSource::Source.find_by_name(config_folder).present?
      end

      def root_path
        Rails.root
      end

      def config_folder
        @options[:config_folder]
      end

      def test_mode?
        return @test_mode unless @test_mode.nil?
        @test_mode = @options[:test_mode].upcase.strip == "TRUE" rescue false
      end

      def import_folder
        global_config["import_folder"] || global_config["export_folder"]
      end

      def move_to_folder
        global_config["move_to_folder"]
      end

      def execute(sequences_only = [])
        log_job_execution

        steps(sequences_only).each do |step|
          t = Task.new(self, step, test_mode?)
          log("Started executing step [#{step.name}]")
          unless t.execute
            log("Failed executing step [#{step.name}]")
            log_job_execution.set_status!('failed')
            return false
          end
          log("Ended executing step [#{step.name}]")
        end

        move_source_files if move_to_folder.present?

        log_job_execution.set_status!('successful')
        return true
      end

      def move_source_files
        FileUtils.mkdir_p move_to_folder
        Dir[File.join(import_folder, "*")].each do |file_path|
          FileUtils.mv(file_path, move_to_folder)
        end
      end

      def steps(sequences_only = [])
        sequences_only = [sequences_only] if sequences_only.present? && !sequences_only.is_a?(Array)

        return sequences_only.present? ? data_source.source_steps.where(load_sequence: sequences_only).order(:load_sequence) : data_source.source_steps.order(:load_sequence)
      end

      def global_config
        return @global_params unless @global_params.blank?

        global_params = data_source.attributes

        @global_params = global_params.merge(@options.stringify_keys)
      end

      def data_source
        data_source = DataSource::Source.find_by_name(config_folder)
      end

      def institution_id
        return @institution_id if @institution_id.present?
        @institution_id = Institution.get_id_from_code(global_config["institution_code"])
        if @institution_id.blank?
          msg  = "Institution not found in database for [#{ global_config["institution_code"] }]."
          log(msg)
          log_job_execution.set_status!('failed')
          raise msg
        end
        @institution_id
      end

      def log_job_execution
        return @log_job_execution if @log_job_execution.present?

        @log_job_execution = Log::JobExecution.create!(
                                                        source_name: config_folder,
                                                        job_type: 'import',
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

module Export
  module Mssql

    class Main
      attr_accessor :folder, :csv_file_path, :test_mode
      def initialize(folder, csv_file_path, test_mode = false)
        @folder, @csv_file_path, @test_mode = folder, csv_file_path, test_mode
      end

      def execute(sequences_only = [], test_mode = false)
        task_files(sequences_only).each do |task_file|
          t = Task.new(self, task_file)
          # TODO testing
          return t.scope
        end
      end

      def task_files(sequences_only = [])
        sequences_only = [sequences_only] if sequences_only.present? && !sequences_only.is_a?(Array)

        # r = Rails.root.join('config','data_sources', folder)
        # TODO 
        full_paths = Dir["/Users/erhanberber/development/NM/metridoc-rails/config/data_sources/#{folder}/**/*"]
        tasks = []
        full_paths.each do |full_path|
          next if File.basename(full_path) == "global.yml"

          table_params = YAML.load_file(full_path)
          seq = table_params["load_sequence"] || 0

          next if sequences_only.present? && !sequences_only.include?(seq)

          tasks << {load_sequence: seq, full_path: full_path}
        end

        tasks.sort_by{|t| t[:load_sequence]}.map{|t| t[:full_path]}
      end

      def global_config
        global_params = {}

        if File.exist?("/Users/erhanberber/development/NM/metridoc-rails/config/data_sources/#{folder}/global.yml")
          global_params = YAML.load_file("/Users/erhanberber/development/NM/metridoc-rails/config/data_sources/#{folder}/global.yml")
        end

        global_params.each do |k, v|
          next unless v.is_a?(String)
          m = v.match(/ENV\["([^\[\]"]*)"\]/)
          if m.present?
            global_params[k] = ENV[m[1]]
          end
        end
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

      def db
        db = TinyTds::Client.new db_opts
      end

    end

  end
end

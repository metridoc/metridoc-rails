class ModelSurrogate < ActiveRecord::Base
  def self.connect_to_remote_database!
      establish_connection ActiveRecord::Base.configurations[Rails.env]['norc']
    end
end

module Import
  module Illiad
  end
end

class ImportHelper::Mssql
  attr_accessor :folder, :csv_file_path, :test_mode
  def initialize(folder, csv_file_path, test_mode = false)
    @folder, @csv_file_path, @test_mode = folder, csv_file_path, test_mode
  end


  def global_config
    r = Rails.root.join('config','data_sources', folder)
    global_params = {}

    if File.exist?(r.join("global.yml"))
      global_params = YAML.load_file(r.join("global.yml"))
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

namespace :import do
  namespace :sqlserver do

    desc "Export MsSQL Data into CSV Files"
    task :export_into_csv, [:config_folder, :output_file_path] => [:environment]  do |_t, args|
      puts "args: #{args.inspect}"
      m = ImportHelper::Mssql.new(args[:config_folder], args[:output_file_path])
       # TODO Testing
       puts "n: #{m.execute(1)}"
    end

  end
end

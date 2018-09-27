namespace :import do
  namespace :sqlserver do

    desc "Generate mssql server migration code for borrowdirect and save into a target file"
    task :generate_borrowdirect_migration, [:output_file_name] => [:environment]  do |_t, args|
      ImportHelper.generate_mssql_migration(args[:output_file_name], 'bd_', 'borrowdirect')
    end

    desc "Generate mssql server migration code for ezborrow and save into a target file"
    task :generate_ezborrow_migration, [:output_file_name] => [:environment]  do |_t, args|
      ImportHelper.generate_mssql_migration(args[:output_file_name], 'ezb_', 'ezborrow')
    end

    desc "Generate mssql server definition for borrowdirect and save into a target file"
    task :generate_borrowdirect_sql_definition, [:output_file_name] => [:environment]  do |_t, args|
      ImportHelper.generate_mssql_definition(args[:output_file_name], 'borrowdirect')
    end

    desc "Generate mssql server definition for ezborrow and save into a target file"
    task :generate_ezborrow_sql_definition, [:output_file_name] => [:environment]  do |_t, args|
      ImportHelper.generate_mssql_definition(args[:output_file_name], 'ezborrow')
    end

  end
end

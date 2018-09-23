namespace :import do
  namespace :mysql do

    desc "Generate migration code for borrrowdirect and save into a target file"
    task :generate_borrowdirect_migration, [:output_file_name] => [:environment]  do |_t, args|
      ImportHelper.generate_mysql_migration(args[:output_file_name], 'bd_', 'borrowdirect')
    end

    desc "Generate migration code for ezborrow and save into a target file"
    task :generate_ezborrow_migration, [:output_file_name] => [:environment]  do |_t, args|
      ImportHelper.generate_mysql_migration(args[:output_file_name], 'ezb_', 'ezborrow')
    end

    desc "Generate migration code for illiad and save into a target file"
    task :generate_illiad_migration, [:output_file_name] => [:environment]  do |_t, args|
      ImportHelper.generate_mysql_migration(args[:output_file_name], 'ill_', 'illiad')
    end

    desc "Copy ezborrow data from mysql into app database"
    task :import_ezborrow_data => [:environment]  do |_t, args|
      ImportHelper.import_mysql_data('ezb_', 'ezborrow')
    end

    desc "Copy borrowdirect data from mysql into app database"
    task :import_borrowdirect_data => [:environment]  do |_t, args|
      ImportHelper.import_mysql_data('bd_', 'borrowdirect')
    end

    desc "Copy illiad data from mysql into app database"
    task :import_illiad_data => [:environment]  do |_t, args|
      ImportHelper.import_mysql_data('ill_', 'illiad')
    end

  end
end
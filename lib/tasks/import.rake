desc "Import Data"
task :import, %i[config_dir test_mode] => :environment do |_t, args|
  config_dir = args.config_dir
  test_mode = args.test_mode == "test"

  puts "config_dir=#{config_dir} test_mode=#{test_mode}"

  if config_dir.blank?
    puts "config_dir missing"
    exit 1
  end

  m = Import::Main.new(config_dir, test_mode)
  exit m.execute ? 0 : 1
end


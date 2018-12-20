desc "Import Data"
task :import, %i[config_dir test_mode single_step] => :environment do |_t, args|
  config_dir = args.config_dir
  test_mode = args.test_mode == "test"
  single_step = args.single_step.present? ? args.single_step.to_i : nil

  puts "config_dir=#{config_dir} test_mode=#{test_mode} single_step=#{single_step}"

  if config_dir.blank?
    puts "config_dir missing"
    exit 1
  end

  m = Import::Main.new(config_dir, test_mode)
  exit m.execute(single_step.present? ? [single_step] : nil) ? 0 : 1
end


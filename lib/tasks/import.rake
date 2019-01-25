require 'rake'
require 'optparse'

desc "Import Data"
task :import => :environment do |_t, args|
  parameters = [
    ["c", "config_folder", "Required Configuration Folder"],
    ["t", "test_mode", "Optional Test mode true/false"],
    ["s", "sigle_step", "Optional Single Step to run"],
    ["i", "import_folder", "Optional Import Folder"],
    ["m", "move_to_folder", "Optional Move to Folder to move the files under after import is done"],
  ]

  options = {}

  option_parser = OptionParser.new
  option_parser.banner = "Usage: rake import -- --options"
  parameters.each do |short, long, description|
    option_parser.on("-#{short} value", "--#{long} value", description) { |parameter_value|
      options[long.to_sym] = parameter_value
    }
  end
  # return `ARGV` with the intended arguments
  args = option_parser.order!(ARGV) {}
  option_parser.parse!(args)

  m = Import::Main.new(options)
  exit m.execute(options[:sigle_step].present? ? [options[:sigle_step].to_i] : nil) ? 0 : 1
end


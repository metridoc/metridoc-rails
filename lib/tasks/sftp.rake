require 'rake'
require 'optparse'

desc "SFTP Data"
task :sftp => :environment do |_t, args|
  parameters = [
    ["c", "config_folder", "Required Configuration Folder"],
    ["t", "test_mode", "Optional Test mode true/false"],
    ["s", "single_step", "Optional Single Step to run"],
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

  m = Export::Sftp::Main.new(options)
  exit m.execute(options[:single_step].present? ? [options[:single_step].to_i] : nil) ? 0 : 1
end


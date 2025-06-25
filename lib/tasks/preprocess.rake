require 'rake'
require 'optparse'

desc "Preprocess Data"
task :preprocess => :environment do |_t, args|
  parameters = [
    ["c", "config_folder", "Required Configuration Folder"],
    ["s", "single_step", "Optional Single Step to run"],
  ]

  options = {}

  option_parser = OptionParser.new
  option_parser.banner = "Usage: rake preprocess -- --options"
  parameters.each do |short, long, description|
    option_parser.on("-#{short} value", "--#{long} value", description) { |parameter_value|
      options[long.to_sym] = parameter_value
    }
  end
  # return `ARGV` with the intended arguments
  args = option_parser.order!(ARGV) {}
  option_parser.parse!(args)

  m = Preprocess::Main.new(options)
  exit m.execute(options[:single_step].present? ? [options[:single_step].to_i] : nil) ? 0 : 1
end

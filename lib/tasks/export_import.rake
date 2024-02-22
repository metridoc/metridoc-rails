require 'rake'
require 'optparse'

namespace "export_import" do

  desc "Generate TODO File for export/import"
  task :prepare, [:outfile] => [:environment] do |_t, args|
    args.with_defaults(:outfile => 'job.todo')
    outfile = args[:outfile]
    parameters = [
      ["c", "config_folder", "Required Configuration Folder"],
      ["f", "from_date", "From Date"],
      ["o", "to_date", "To Date"]
    ]

    options = {}

    option_parser = OptionParser.new
    option_parser.banner = "Usage: rake import -- --options"
    parameters.each do |short, long, description|
      option_parser.on("-#{short} value", "--#{long} value", description) { |parameter_value|
        options[long.to_sym] = parameter_value
      }
    end

    args = option_parser.order!(ARGV) {}
    option_parser.parse!(args)
    File.open(outfile, 'w') do |f|
      f.write("---\n")
      options.each do |k,v| f.write("#{k}: #{v}\n") end
    end
  end

  desc "Export data and import it; Execute 'rake make_todo' first"
  task :execute, [:infile] => [:environment] do |_t, args|
    args.with_defaults(:infile => 'job.todo')
    infile = args[:infile]

    LOGGER = Logger.new $stdout
    LOGGER.level = Logger::INFO

    TodoRunner.define do
      start :export

      task :export, on_fail: :FAIL, next_step: :import do |todo_file|
        job = Psych.safe_load(todo_file, aliases: true)
        options = {}
        job.each do |k,v| options[k.to_sym] = v end
        success = Export::Database::Main.new(options).execute()

        if success
          job['run_date'] = Date.today.to_s
          todo_file.rewrite(job.to_yaml)
        end

        success
      end

      task :import, on_fail: :FAIL, next_step: :bookkeeping do |todo_file|
        job = Psych.safe_load(todo_file, aliases: true)
        options = {}
        job.each do |k,v| options[k.to_sym] = v end
        m = Import::Main.new(options)
        m.execute()
      end

      task :bookkeeping, on_fail: :FAIL, next_step: :SUCCESS do |todo_file|
        job = Psych.safe_load(todo_file, aliases: true)
        config_folder = job['config_folder']
        from_date = job['from_date']
        to_date = job['to_date']
        run_date = job['run_date']
        BookkeepingHelper.update_bookkeeping_table(config_folder, from_date, to_date)
      end
    end

    TodoRunner.run infile
  end
end

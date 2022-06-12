namespace "maintenance" do

  desc "purge jobs"
  task purge_jobs: :environment do |_t, args|
    puts "Started purging jobs"
    Log::JobExecution.where("started_at < ?", 6.months.ago).destroy_all
    puts "Finished purging jobs"
  end

end

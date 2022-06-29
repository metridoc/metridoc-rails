namespace "maintenance" do

  desc "purge jobs"
  task purge_jobs: :environment do |_t, args|
    puts "Started purging jobs"
    ["reshare", "illiad", "ezborrow"].each do |source_name|
      puts "Purging #{source_name} jobs"
      Log::JobExecution
        .of_source(source_name)
        .where("started_at < ?", 6.months.ago)
        .where(" id NOT IN (SELECT id FROM log_job_executions WHERE source_name ILIKE ? AND status = 'successful' ORDER BY id DESC LIMIT 1) ", "%#{source_name}%")
        .destroy_all
    end
    puts "Finished purging jobs"
  end

end

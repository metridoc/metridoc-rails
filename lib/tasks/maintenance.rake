namespace "maintenance" do

  desc "purge jobs"
  task purge_jobs: :environment do |_t, args|
    puts "Started purging jobs"
    # List all the distinct sources that are tracked
    sources = Log::JobExecution.select(:source_name).distinct
    # Loop through all the sources
    sources.each do |source|
      # Extract the source name from the sources
      source_name = source.source_name
      puts "Purging #{source_name} jobs"
      # Remove all jobs older than 6 months
      # Keep the last successful job even if it is more than 6 months old.
      Log::JobExecution
        .of_source(source_name)
        .where("started_at < ?", 6.months.ago)
        .where(
          """id NOT IN (
            SELECT id
            FROM log_job_executions
            WHERE source_name ILIKE ?
              AND status = 'successful'
            ORDER BY id DESC
            LIMIT 1
            )""",
          "%#{source_name}%"
        )
        .destroy_all
    end
    puts "Finished purging jobs"
  end

end

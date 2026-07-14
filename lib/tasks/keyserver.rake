require 'csv'

namespace :keyserver do
  desc "Deduplicate keyserver_computers.csv by Computer Name, keeping the row with the most recent LastAudit (falling back to LastStartup, then LastLogin)"
  task :dedupe_computers, [:file_path] => :environment do |_t, args|
    file_path = args[:file_path] || '/tmp/keyserver/keyserver_computers.csv'
    raise "File not found: #{file_path}" unless File.exist?(file_path)

    recency_columns = ['LastAudit', 'LastStartup', 'LastLogin']

    recency_of = lambda do |row|
      recency_columns.each do |col|
        val = row[col]
        next if val.blank?

        begin
          return Time.parse(val)
        rescue ArgumentError
          next
        end
      end
      nil
    end

    rows = CSV.read(file_path, headers: true, encoding: 'bom|utf-8')
    headers = rows.headers

    best_by_name = {}
    seen_order = []

    rows.each do |row|
      name = row['Computer Name']
      next if name.blank?

      seen_order << name unless best_by_name.key?(name)

      existing = best_by_name[name]
      if existing.nil?
        best_by_name[name] = row
        next
      end

      existing_recency = recency_of.call(existing)
      candidate_recency = recency_of.call(row)

      # Prefer the candidate only if it has a parseable timestamp and either
      # the existing row has none or the candidate's is later. Otherwise the
      # first-seen row for this name is kept.
      if candidate_recency && (existing_recency.nil? || candidate_recency > existing_recency)
        best_by_name[name] = row
      end
    end

    n_dropped = rows.size - seen_order.size
    puts "Read #{rows.size} rows for #{seen_order.size} distinct computer names, dropping #{n_dropped} duplicate row(s)."

    tmp_path = "#{file_path}.tmp"
    CSV.open(tmp_path, 'w') do |csv|
      csv << headers
      seen_order.each { |name| csv << best_by_name[name].fields }
    end
    FileUtils.mv(tmp_path, file_path)

    puts "Wrote deduplicated file to #{file_path} (#{seen_order.size} rows)."
  end

  desc "Add a location column to the events CSV, matched from the sessions CSV by computer_name"
  task :add_event_locations, [:events_path, :sessions_path, :output_path] => :environment do |_t, args|
    events_path   = args[:events_path]   || '/tmp/keyserver/events.csv'
    sessions_path = args[:sessions_path] || '/tmp/keyserver/sessions.csv'
    output_path   = args[:output_path]   || events_path

    raise "Events file not found: #{events_path}"     unless File.exist?(events_path)
    raise "Sessions file not found: #{sessions_path}"  unless File.exist?(sessions_path)

    # A computer_name maps to at most one non-blank location in practice, but
    # take the first one seen either way rather than raising on the rare
    # conflicting export.
    location_by_computer = {}
    CSV.foreach(sessions_path, headers: true, encoding: 'bom|utf-8') do |row|
      name = row['computer_name']
      next if name.blank?

      location = row['location']
      next if location.blank?

      location_by_computer[name] ||= location
    end

    puts "Loaded locations for #{location_by_computer.size} computers from #{sessions_path}."

    tmp_path = "#{output_path}.tmp"
    n_rows = 0
    n_matched = 0

    CSV.open(tmp_path, 'w') do |out|
      CSV.foreach(events_path, headers: true, return_headers: true, encoding: 'bom|utf-8') do |row|
        if row.header_row?
          out << (row.headers + ['location'])
          next
        end

        n_rows += 1
        location = location_by_computer[row['computer_name']]
        n_matched += 1 if location

        out << (row.fields + [location])
      end
    end

    FileUtils.mv(tmp_path, output_path)

    puts "Wrote #{n_rows} rows to #{output_path} (#{n_matched} matched a location, #{n_rows - n_matched} left blank)."
  end
end

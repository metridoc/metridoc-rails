require 'roo'

class Tools::FileUploadImport < ApplicationRecord

  belongs_to :uploaded_by, class_name: "AdminUser"
  has_many :file_upload_import_logs, -> { order(:sequence) }, class_name: "Tools::FileUploadImportLog"

  before_create :set_defaults
  # Post Rails 7.1, must appear BEFORE after_commit
  has_one_attached :uploaded_file
  # Save the active storage blob
  after_commit :queue_process

  UPLOADABLE_MODELS = [
    Consultation::Interaction,
    GeoData::CountryCode,
    Keyserver::StatusTerm,
    Keyserver::PlatformTerm,
    Keyserver::ReasonTerm,
    Keyserver::Program,
    Keyserver::EventTerm,
    Keyserver::Division,
    Keyserver::Computer,
    Keyserver::CpuTypeTerm,
    Keyserver::Usage,
    Ipeds::Completion,
    Ipeds::Directory,
    Ipeds::Program,
    Ipeds::CompletionSchema,
    Ipeds::DirectorySchema,
    Ipeds::ProgramSchema,
    Ipeds::StemCipcode,
    Ipeds::Cipcode,
    Upenn::Enrollment,
    LibraryStaff::Census,
    Springshare::Libanswers::Queue,
    Springshare::Libanswers::Ticket,
    Springshare::Libchat::Chat
  ]

  validates :target_model, presence: true
  validates :uploaded_file, attached: true

  def process
    return unless self.status.blank? || self.status == 'pending'

    file_upload_import_logs.destroy_all
    file_upload_import_logs.reload

    log "Starting to process."
    self.update_columns(last_attempted_at: Time.now, status: "in-progress")
    FileUploadImportMailer.with(file_upload_import: self).started_notice.deliver_now

    import

    FileUploadImportMailer.with(file_upload_import: Tools::FileUploadImport.find(id)).finished_notice.deliver_now
    rescue SignalException => se
      log "Process terminated => #{se.message}"
      update_columns(status: 'pending')
      raise se
  end

  # Get the extension of the uploaded file
  def extension
    self.uploaded_file.filename.extension_without_delimiter
  end

  # Get the file_path of the uploaded file
  def file_path
    decompress(
      ActiveStorage::Blob.service.path_for(self.uploaded_file.key)
    )
  end

  # Open the Spreadsheet
  # This can be a csv, xls, xlsx and the Roo gem will handle all of them
  def spreadsheet
    Roo::Spreadsheet.open(
      file_path, 
      {
        extension: extension.to_sym(), 
        csv_options: { encoding: 'bom|utf-8' } 
      }
    )
  rescue => ex
    log "Error =>  [#{ex.message}]"
    raise ex
  end

  # Count the number of rows, excluding the header row
  def calculate_rows_to_process
    # Get the index of the last row
    spreadsheet.last_row-1
  end

  def target_class
    self.target_model.constantize
  end

  # Get the header row and update the column names
  def get_headers
    headers = spreadsheet.first.map{|c| Util.column_to_attribute(c) }
    headers.each do |column_name|
      if target_class.columns_hash[column_name].blank?
        headers[headers.index(column_name)] = column_name.split(/\_+/).first
      end

      # Some uploadable files will have an id column.
      # Rename the id column as defined in the model.
      if (column_name == "id") && (target_class.respond_to? :alternate_id)
        headers[headers.index(column_name)] = target_class.alternate_id
      end
    end

    # Return the headers
    headers
  end

  def import
    batch_size = 1000
    headers = get_headers

    unmatched_columns = headers.select { |column_name| target_class.columns_hash[column_name].blank? }
    if unmatched_columns.present?
      log "!!WARNING!!: These columns are not processed: [#{unmatched_columns.join(", ")}]"
    end

    n_errors = 0
    n_inserted = 0

    self.update_columns(total_rows_to_process: calculate_rows_to_process, n_rows_processed: 0)

    success = true
    Tools::FileUploadImport.transaction do

      records = []
      # Loop through each row of the spreadsheet
      spreadsheet.drop(1).each_with_index do |row, n|
        if n_errors >= 100
          log "Too many errors #{n_errors}, exiting!"
          records = []
          break
        end

        row_error = false
        attributes = {}
        # Loop through each column of the spreadsheet
        headers.each_with_index do |column_name, i|
          # Ensure all values are strings
          val = row[i].to_s

          next if target_class.columns_hash[column_name].blank?

          # Check for valid integer for integer columns, requires a string input
          if target_class.columns_hash[column_name].type == :integer && !Util.valid_integer?(val)
            log "Invalid integer [#{val}] in column: #{column_name} row: #{row.join(",")}"
            n_errors = n_errors + 1
            row_error = true
            next
          end
          # Check for valid datetimes for datetime columns, requires a string input
          if target_class.columns_hash[column_name].type == :datetime && !Util.valid_datetime?(val)
            log "Invalid datetime [#{val}] in column: #{column_name} row: #{row.join(",")}"
            n_errors = n_errors + 1
            row_error = true
            next
          end
          # Check for valid dates for date columns, requires a string input
          if target_class.columns_hash[column_name].type == :date && !Util.valid_datetime?(val)
            log "Invalid date [#{val}] in column: #{column_name} row: #{row.join(",")}"
            n_errors = n_errors + 1
            row_error = true
            next
          end

          # If the target column is a datetime type, then turn the value into a datetime
          val = Util.parse_datetime(val) if target_class.columns_hash[column_name].type == :datetime

          # If the target column is an interval type, then turn the value into an interval
          # Takes strings like 01:02:30 and makes them like PT01H02M30S for parsing
          if target_class.columns_hash[column_name].type == :interval
            val = ActiveSupport::Duration.parse(
              "PT" + val.split(":").zip(["H", "M", "S"]).flatten.join()
              )
          end

          attributes[column_name] = val
        end

        # Skip this row if there were any errors
        next if row_error

        records << target_class.new(attributes)

        if records.size >= batch_size
          break if cancelled?
          return_val = import_records(target_class, records)
          if return_val[:status] == 'failed'
            n_errors += return_val[:n_errors]
          else
            n_inserted += return_val[:n_inserted]
            update_progress(n_inserted)
          end
          records = []
        end

      end

      if records.size > 0 && !cancelled?
        return_val = import_records(target_class, records)
        if return_val[:status] == 'failed'
          n_errors += return_val[:n_errors]
        else
          n_inserted += return_val[:n_inserted]
          update_progress(n_inserted)
        end
        records = []
      end

      if cancelled?
        log "Upload has been cancelled."
        log "Rolling back the upload."
        raise ActiveRecord::Rollback, "Rolling back the upload."
      end

      if n_errors > 0
        log "#{n_errors} errors encountered."
        log "Rolling back the upload."
        success = false
        raise ActiveRecord::Rollback, "Rolling back the upload."
      else
        log "#{n_inserted} rows inserted successfully."
        log "Finished importing #{target_model_name}."
      end

    end #transaction

    self.update_columns(status: success ? "success" : "failed") unless cancelled?

    # Automatically update tables after the import is complete if 
    # defined in the model
    if target_class.respond_to?(:update_after_import) && success
      log "Updating tables after import."
      target_class.update_after_import
      log "Finished updating tables after import."
    end

    save!
  end

  def cancel
    Tools::FileUploadImport.find(id).update_columns(status: 'cancelled', total_rows_to_process: nil, n_rows_processed: nil)
  end

  def cancelled?
    return Tools::FileUploadImport.find(id).status == 'cancelled'
  end

  def update_progress(n_rows_processed)
    Thread.new do
      ActiveRecord::Base.connection_pool.with_connection do
        Tools::FileUploadImport.find(id).update_columns(n_rows_processed: n_rows_processed)
      end
    end
  end

  def progress_text
    n_rows_processed && n_rows_processed > 0 ? "#{n_rows_processed} of #{total_rows_to_process} rows processed" : "-"
  end

  def import_records(target_class, records)
    begin
      if target_class.respond_to?(:on_conflict_update)
        target_class.import records, on_duplicate_key_update: target_class.on_conflict_update
      else
        target_class.import records
      end
      return {status: 'success', n_inserted: records.size}
    rescue => ex
      log "Error while importing records => #{ex.message}"
    end

    n_errors = 0
    log "Switching to individual mode"
    records.each do |record|
      begin
        unless record.save
          log "Failed saving #{record.inspect} error: #{records.errors.full_messages.join(", ")}"
          n_errors += 1
        end
      rescue => ex
        log "Error saving record => #{ex.message} record:[#{record.inspect}]"
        n_errors += 1
      end
    end

    return n_errors > 0 ? {status: 'failed', n_errors: n_errors} : {status: 'success', n_inserted: records.size}
  end

  def decompress(file_path)
    reader = Zlib::GzipReader.open(file_path)
    file_name = "#{File.basename(file_path)}.csv"
    decompressed_path = File.join(File.dirname(file_path), file_name)
    File.open(decompressed_path, 'w') do |f|
      reader.each_line do |line|
        f.write(line)
      end
    end
    decompressed_path
  rescue Zlib::GzipFile::Error
    file_path
  end

  def log(s)
    sequence = file_upload_import_logs.map(&:sequence).max.to_i + 1
    puts "#{sequence} - #{s}"
    file_upload_import_logs.build(log_text: s, sequence: sequence, log_datetime: Time.now)
  end

  def target_model_name
    self.target_model.constantize.model_name.human
  end

  private
  def set_defaults
    self.uploaded_at = Time.now if self.uploaded_at.blank?
  end

  def queue_process
    return unless self.status.blank? || self.status == 'pending'
    n = calculate_rows_to_process
    self.delay(queue: "#{n > 5000 ? "large" : "default"}").process
  end

end

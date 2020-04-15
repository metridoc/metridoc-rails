class Tools::FileUploadImport < ApplicationRecord
  has_one_attached :uploaded_file
  belongs_to :uploaded_by, class_name: "AdminUser"
  has_many :file_upload_import_logs, -> { order(:sequence) }, class_name: "Tools::FileUploadImportLog"

  before_create :set_defaults
  after_create  :queue_process

  UPLOADABLE_MODELS = [ Misc::ConsultationData,
                        Keyserver::StatusTerm,
                        Keyserver::PlatformTerm,
                        Keyserver::ReasonTerm,
                        Keyserver::Program,
                        Keyserver::EventTerm,
                        Keyserver::Division,
                        Keyserver::Computer,
                        Keyserver::CpuTypeTerm,
                        Keyserver::Usage,
                        GateCount::CardSwipe,
                      ]

  validates_presence_of :target_model, :uploaded_file

  def process
    return unless self.status.blank?

    csv_file_path = ActiveStorage::Blob.service.send(:path_for, self.uploaded_file.key)
    target_class = self.target_model.constantize

    file_upload_import_logs.destroy_all
    file_upload_import_logs.reload

    log "Starting to process."
    self.update_columns(last_attempted_at: Time.now, status: "in-progress")
    FileUploadImportMailer.with(file_upload_import: self).started_notice.deliver_now

    self.update_columns(status: import(csv_file_path, target_class) ? "success" : "failed")
    log "Finished processing."
    FileUploadImportMailer.with(file_upload_import: self).finished_notice.deliver_now
  end

  def import(csv_file_path, target_class)
    batch_size = 100
    csv = CSV.read(csv_file_path, {encoding: 'ISO-8859-1'})

    headers = csv.first.map{|c| c.strip.underscore.gsub(/[\s\/]+/, '_').downcase }

    unmatched_columns = headers.select { |column_name| target_class.columns_hash[column_name].blank? }
    if unmatched_columns.present?
      log "!!WARNING!!: These columns are not processed: [#{unmatched_columns.join(", ")}]"
    end

    n_errors = 0
    n_inserted = 0

    update_columns(total_rows_to_process: (csv.size-1), n_rows_processed: 0)

    Tools::FileUploadImport.transaction do

      records = []
      csv.drop(1).each_with_index do |row, n|
        if n_errors >= 100
          log "Too many errors #{n_errors}, exiting!"
          records = []
          break
        end

        cols = {}
        headers.each_with_index do |k,i| 
          cols[k.to_sym] = row[i]
        end

        row_error = false
        attributes = {}
        headers.each do |column_name|
          val = cols[column_name.to_sym]

          next if target_class.columns_hash[column_name].blank?

          if target_class.columns_hash[column_name].type == :integer && !Util.valid_integer?(val)
            log "Invalid integer [#{val}] in column: #{column_name} row: #{row.join(",")}"
            n_errors = n_errors + 1
            row_error = true
            next
          end
          if target_class.columns_hash[column_name].type == :datetime && !Util.valid_datetime?(val)
            log "Invalid datetime [#{val}] in column: #{column_name} row: #{row.join(",")}"
            n_errors = n_errors + 1
            row_error = true
            next
          end
          if target_class.columns_hash[column_name].type == :date && !Util.valid_datetime?(val)
            log "Invalid date [#{val}] in column: #{column_name} row: #{row.join(",")}"
            n_errors = n_errors + 1
            row_error = true
            next
          end

          val = Util.parse_datetime(val) if target_class.columns_hash[column_name].type == :datetime

          attributes[column_name] = val
        end

        next if row_error

        records << target_class.new(attributes)

        if records.size >= batch_size
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

      if records.size > 0
        return_val = import_records(target_class, records)
        if return_val[:status] == 'failed'
          n_errors += return_val[:n_errors]
        else
          n_inserted += return_val[:n_inserted]
          update_progress(n_inserted)
        end
        records = []
      end

      if n_errors > 0
        log "#{n_errors} errors encountered."
        log "Rolling back the load."
        raise ActiveRecord::Rollback, "Rolling back the load."
      else
        log "#{n_inserted} rows inserted successfully."
        log "Finished importing #{target_model_name}."
      end

    end #transaction

    save!

    return n_errors <= 0
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
      target_class.import records
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
    self.delay.process if self.status.blank? || self.status == 'pending'
  end

end

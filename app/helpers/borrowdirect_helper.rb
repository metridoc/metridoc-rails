module BorrowdirectHelper

  def display_names_bd(institution_ids)
    render_ids = []
    institution_ids.each do |id, amount|
      render_ids << [Borrowdirect::Institution.find_by(library_id: id).nil? ?
                       "Unfilled" :
                       "#{Borrowdirect::Institution.find_by(library_id: id)
                                                   .institution_name} (#{id})",
                     amount]
    end
    return render_ids
  end

  # Note: you have to restart the server to get access
  # to any changes in the helper methods!

  def get_library_name(library_id)
    if library_id.to_i < 0 or library_id.nil?
      return "All Libraries"
    end

    return Borrowdirect::Institution.find_by(library_id: library_id).nil? ?
             "Not supplied" :
             "#{Borrowdirect::Institution.find_by(library_id: library_id)
                                         .institution_name}"
  end

  # Create an array of arrays that map the library symbol to the library id
  def library_map_bd()
    library_map = []
    # Loop through all member institutions
    Borrowdirect::Institution.all.each do |lib|
      # Skip the "Default" case
      next if lib.library_id == 0
      # Skip the CRL, OCLC, OORII, and RapidILL cases
      next if [10000010, 9999997, 9999996, 9999995].include? lib.library_id
      library_map << [lib.library_symbol, lib.library_id]
    end
    # Return a sorted map
    return library_map.sort
  end

  # Function to calculate the fiscal year ranges for
  # both the requested year and the previous year
  def fiscal_year_ranges_bd(fiscal_year)
    start_date = Date.new(fiscal_year - 1, 7, 1)
    end_date = [Date.today, Date.new(fiscal_year, 6, 30)].min
    this_year = start_date..end_date
    last_year = (start_date - 1.year)..(end_date - 1.year)
    return this_year, last_year
  end

  # Function to specify the months to display
  def display_months_bd(this_year)
    # Calculate what the last month is
    last_month = this_year.last.month
    # Return an ordered array of the past months of the fiscal year
    return last_month >= 7 ?
             last_month.downto(7).to_a :
             last_month.downto(1).to_a + 12.downto(7).to_a
  end

  # Method to construct the standard query to be used across all queries
  # Options for the initial query, the library_id (if given),
  # if the request is for borrowing or for the all libraries summary.
  def base_query_bd(input_query, options = {})

    # Set up the default conditions
    library_id = options.fetch(:library_id, nil)
    get_borrowing = options.fetch(:get_borrowing, false)
    get_summary = options.fetch(:get_summary, false)
    get_monthly = options.fetch(:get_monthly, false)
    get_successful = options.fetch(:get_successful, true)

    # Ensure the borrower and lender are not the same
    output_query = input_query.where.not('borrower = lender')

    # To get only successful requests
    if get_successful
      # Check that the query was filled
      output_query = output_query.where.not(:supplier_code => 'List Exhausted')
      # Check that a process date is recorded
      output_query = output_query.where.not(:process_date => nil)
    end

    # Specify a particular lender or borrower if provided
    if not library_id.nil?
      output_query = get_borrowing ?
                       output_query.where(borrower: library_id) :
                       output_query.where(lender: library_id)
    end

    # No default rollup function available in ActiveRecord
    if not get_summary
      # Group by borrower or lender based on input
      output_query = get_borrowing ?
                       output_query.group(:lender) : output_query.group(:borrower)
    end

    # Group by month when requested
    output_query = get_monthly ?
                     output_query.group("CAST(EXTRACT (MONTH FROM request_date) AS int)") :
                     output_query

    return output_query
  end

  # Function to query for all items lent or borrowed in two successive
  # fiscal years
  # this_year: The primary fiscal year of interest
  # last_year: The previous fiscal year (truncated to primary year's end)
  # library_id: To be used for selection of particular library stats
  # get_monthly: Boolean to query for monthly grouped counts
  # get_borrowing: Boolean to query for borrowing versus lending
  # get_summary: Boolean to query for the summary of all libraries
  def count_library_items_bd(this_year:, last_year:, library_id:, get_monthly:,
                             get_borrowing:, get_summary:)

    # Distinct request numbers in bibliography
    query = Borrowdirect::Bibliography.select(:request_number).distinct

    options = {
      :library_id => library_id,
      :get_monthly => get_monthly,
      :get_borrowing => get_borrowing,
      :get_summary => get_summary
    }

    # Construct standard query
    query = base_query_bd(query, **options)

    # Count all unique requests from this year and last year
    this_query = query.where(request_date: this_year).count
    last_query = query.where(request_date: last_year).count

    return this_query, last_query
  end

  # Function to combine the results of the queries for item counts
  def count_items_bd(options = {})

    # Returns a hash of library id to number
    this_by_library, last_by_library = count_library_items_bd(
      **options.merge(:get_summary => false))

    # Get the grand total for all libraries
    # This is faster than doing yet another SQL call
    # For some silly reason RUBY doesn't do SQL rollup
    get_monthly = options.fetch(:get_monthly, false)
    if get_monthly
      # Accumulate on entries
      (1..12).each do |month|
        this_by_library[[-1, month]] = this_by_library.sum {
          |k, v| k.last == month ? v : 0
        }
        last_by_library[[-1, month]] = last_by_library.sum {
          |k, v| k.last == month ? v : 0
        }
      end
    else
      # Accumulation entries
      this_by_library[-1] = this_by_library.sum { |k, v| v }
      last_by_library[-1] = last_by_library.sum { |k, v| v }
    end

    return this_by_library, last_by_library
  end

  def get_fill_rate_bd(options = {})
    # Distinct request numbers in bibliography
    query = Borrowdirect::Bibliography.select(:request_number).distinct
    # Only want to know about the current year
    query = query.where(request_date: options[:this_year])

    # Returns a hash of library_id to number
    # Construct successful requests query
    successful_requests = base_query_bd(query,
                                     **options.merge(:get_successful => true)).count
    # Construct all requests query
    all_requests = base_query_bd(query,
                              **options.merge(:get_successful => false)).count

    # Find the grand total, faster than another SQL query
    # Ruby on Rails doesn't have SQL rollup
    successful_requests[-1] = successful_requests.sum { |k, v| v }
    all_requests[-1] = all_requests.sum { |k, v| v }

    # Fill an output hash with the fill rate
    fill_rate = {}

    all_requests.each do |library_id, count|
      successful_count = successful_requests.fetch(library_id, 0)
      rate = count != 0 ?
               successful_count.to_f / count : -1
      # Reformat the output to 0.00
      fill_rate[library_id] = sprintf('%.2f', rate)
    end

    return fill_rate
  end

  def get_library_turnaround_time(options = {})
    # Distinct request numbers in bibliography
    query = Borrowdirect::Bibliography
    # Only want to know about the current year
    query = query.where(request_date: options[:this_year])
    # Set up the base restrictions
    query = base_query_bd(query, **options)
    query = query.joins("INNER JOIN
      borrowdirect_min_ship_dates AS ship
      ON borrowdirect_bibliographies.request_number = ship.request_number")

    # Extract booleans from options
    get_borrowing = options.fetch(:get_borrowing, false)
    get_summary = options.fetch(:get_summary, false)

    # Add the borrower or lender column to the output
    unless get_summary
      if get_borrowing
        query = query.select("lender")
      else
        query = query.select("borrower")
      end
    end

    # Create the average of the difference in the timestamps
    query = query.select(
      "AVG(EXTRACT (epoch FROM process_date - request_date)) as req_to_rec,
      AVG(EXTRACT (epoch FROM ship.min_ship_date - request_date)) as req_to_shp,
      AVG(EXTRACT (epoch FROM process_date - ship.min_ship_date)) as shp_to_rec
      ")

    # Empty hashes to fill
    req_to_rec = {}
    req_to_shp = {}
    shp_to_rec = {}

    # Fill hashes from all rows
    query.all.each do |row|
      library_id = -1
      if not get_summary
        if get_borrowing
          library_id = row["lender"]
        else
          library_id = row["borrower"]
        end
      end

      if row["req_to_rec"].present?
        req_to_rec[library_id] = row["req_to_rec"]
      end
      if row["req_to_shp"].present?
        req_to_shp[library_id] = row["req_to_shp"]
      end
      if row["shp_to_rec"].present?
        shp_to_rec[library_id] = row["shp_to_rec"]
      end
    end

    return req_to_rec, req_to_shp, shp_to_rec
  end

  # Method to build the turnaround portion of the table
  def get_turnaround_time(options = {})
    by_library_req_to_rec, by_library_req_to_shp, by_library_shp_to_rec = get_library_turnaround_time(
      **options.merge(:get_summary => false))
    all_libraries_req_to_rec, all_libraries_req_to_shp, all_libraries_shp_to_rec = get_library_turnaround_time(
      **options.merge(:get_summary => true))

    # Add the all library counts to the hash
    by_library_req_to_rec.merge!(all_libraries_req_to_rec)
    by_library_req_to_shp.merge!(all_libraries_req_to_shp)
    by_library_shp_to_rec.merge!(all_libraries_shp_to_rec)

    return by_library_req_to_rec, by_library_req_to_shp, by_library_shp_to_rec
  end

  # Method to check for a key and format the number appropriately
  # This will be used for big integers (> 1000)
  def format_into_days_bd(input_hash, test_key)
    output = "---"
    if input_hash.key?(test_key)
      output = sprintf('%.2f', input_hash[test_key] / 60 / 60 / 24)
    end
    return output
  end

  # Method to check for a key and format the number appropriately
  # This will be used for big integers (> 1000)
  def format_big_number_bd(input_hash, test_key)
    output = "---"
    if input_hash.key?(test_key)
      output = ActiveSupport::NumberHelper.number_to_delimited(input_hash[test_key])
    end
    return output
  end

  # Method to prepare the full summary table.
  # Takes inputs of library_id (default is nil)
  # and fiscal_year (default is 2021)
  def prepare_summary_table(fiscal_year = 2021, library_id = nil, get_borrowing = false)

    this_year, last_year = fiscal_year_ranges_bd(fiscal_year)

    options = {
      :this_year => this_year,
      :last_year => last_year,
      :library_id => library_id,
      :get_monthly => false,
      :get_borrowing => get_borrowing
    }

    # Get the library turn around time
    req_to_rec, req_to_shp, shp_to_rec = get_turnaround_time(**options)

    # Get the library fill rate
    fill_rate = get_fill_rate_bd(**options)

    # Get the yearly item count
    current_items, previous_items = count_items_bd(**options)

    # Get the monthly item counts (do this last!)
    options[:get_monthly] = true
    current_monthly_items, previous_monthly_items = count_items_bd(**options)

    # Get the list of months to dynamically display
    display_months = display_months_bd(this_year)

    # The the list of libraries
    library_map = [["All Libraries", -1]] + library_map_bd()

    # Prepare the output table for display
    output_table = []

    library_map.each do |library_symbol, library_id|
      # Get the library_name and library_id
      output_row = [library_symbol]
      output_row << format_into_days_bd(req_to_rec, library_id)
      output_row << format_into_days_bd(req_to_shp, library_id)
      output_row << format_into_days_bd(shp_to_rec, library_id)
      output_row << format_big_number_bd(current_items, library_id)
      output_row << (fill_rate.key?(library_id) ?
                       fill_rate[library_id] : "---")
      output_row << format_big_number_bd(previous_items, library_id)

      # Loop through the monthly information
      display_months.each do |month|
        output_row << format_big_number_bd(current_monthly_items,
                                        [library_id, month])
        output_row << format_big_number_bd(previous_monthly_items,
                                        [library_id, month])
      end

      # Append this row to the output table
      output_table << output_row
    end

    return output_table, display_months

  end

end

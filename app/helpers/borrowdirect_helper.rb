module BorrowdirectHelper

  def display_names_bd(institution_ids)
    render_ids = []
    institution_ids.each do |id, amount|
      render_ids << [Borrowdirect::Institution.find_by(library_id: id).nil? ?
        "Not supplied" :
        "#{Borrowdirect::Institution.find_by(library_id: id)
          .institution_name} (#{id})",
          amount]
    end
    return render_ids
  end

  # Note: you have to restart the server to get access
  # to any changes in the helper methods!

  # Create an array of arrays that map the library symbol to the library id
  def library_map_bd()
    library_map = []
    # Loop through all member institutions
    Borrowdirect::Institution.all.each do |lib|
      # Skip the "Default" case
      next if lib.library_id == 0
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
  def base_query(input_query, options = {})

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
    query = base_query(query, **options)

    # Count all unique requests from this year and last year
    this_query = query.where(request_date: this_year).count
    last_query = query.where(request_date: last_year).count

    return this_query, last_query
  end

  # Function to combine the results of the queries for item counts
  def count_items_bd(options = {})

    # Get all libraries information
    # Returns a single number
    this_all_libraries, last_all_libraries = count_library_items_bd(
      **options.merge(:get_summary => true))

    # Returns a hash of library id to number
    this_by_library, last_by_library = count_library_items_bd(
      **options.merge(:get_summary => false))

    # Special key construction for monthly totals
    if this_all_libraries.respond_to?(:each)
      this_all_libraries.each do |month, total|
        this_by_library[[-1, month]] = total
      end
      last_all_libraries.each do |month, total|
        last_by_library[[-1, month]] = total
      end
    else
      # Assume yearly summary
      this_by_library[-1] = this_all_libraries
      last_by_library[-1] = last_all_libraries
    end

    return this_by_library, last_by_library

  end

  def get_fill_rate_bd(options={})
    # Distinct request numbers in bibliography
    query = Borrowdirect::Bibliography.select(:request_number).distinct
    # Only want to know about the current year
    query = query.where(request_date: options[:this_year])

    # Returns a hash of library_id to number
    # Construct successful requests query
    successful_requests = base_query(query,
      **options.merge(:get_successful => true)).count
    # Construct all requests query
    all_requests = base_query(query,
      **options.merge(:get_successful => false)).count

    # Returns integers
    # Construct successful requests query
    successful_request_summary = base_query(query,
      **options.merge({:get_successful => true, :get_summary => true})).count
    # Construct all requests query
    all_request_summary = base_query(query,
      **options.merge({:get_successful => false, :get_summary => true})).count

    # Fill an output hash with the fill rate
    fill_rate = {}
    fill_rate[-1] = all_request_summary != 0 ?
      successful_request_summary / all_request_summary.to_f : -1

    all_requests.each do |library_id, count|
      successful_count = successful_requests.fetch(library_id, 0)
      fill_rate[library_id] = count != 0 ?
        successful_count.to_f / count : -1
    end

    # Reformat the output to 0.00
    fill_rate.each do |library_id, rate|
      fill_rate[library_id] = sprintf('%.2f', rate)
    end

    return fill_rate
  end

  def get_library_turnaround_time(options={})
    # Distinct request numbers in bibliography
    query = Borrowdirect::Bibliography
    # Only want to know about the current year
    query = query.where(request_date: options[:this_year])
    # Set up the base restrictions
    query = base_query(query, **options)
    query = query.joins("INNER JOIN
      borrowdirect_min_ship_dates ON
      borrowdirect_bibliographies.request_number = borrowdirect_min_ship_dates.request_number")

    # Stupidly have to query three separate times?
    # Can potentially make a single query where I rename all things (i.e. AS req_to_rec)
    # Then create a hash by hand with a loop over query.all.each of
    # hash[row["borrower"]] = row["req_to_rec"] ???
    req_to_rec = query.average("EXTRACT (epoch FROM process_date - request_date)")
    req_to_shp = query.average(
      "EXTRACT (epoch FROM borrowdirect_min_ship_dates.min_ship_date - request_date)")
    shp_to_rec = query.average(
      "EXTRACT (epoch FROM process_date - borrowdirect_min_ship_dates.min_ship_date)")

    return req_to_rec, req_to_shp, shp_to_rec
  end

  # Method to build the turnaround portion of the table
  def get_turnaround_time(options={})
    by_library_req_to_rec, by_library_req_to_shp, by_library_shp_to_rec = get_library_turnaround_time(
      **options.merge(:get_summary => false))
    all_libraries_req_to_rec, all_libraries_req_to_shp, all_libraries_shp_to_rec = get_library_turnaround_time(
      **options.merge(:get_summary => true))

    # Add the all library counts to the hash
    by_library_req_to_rec[-1] = all_libraries_req_to_rec
    by_library_req_to_shp[-1] = all_libraries_req_to_shp
    by_library_shp_to_rec[-1] = all_libraries_shp_to_rec

    return by_library_req_to_rec, by_library_req_to_shp, by_library_shp_to_rec
  end

  # Method to check for a key and format the number appropriately
  # This will be used for big integers (> 1000)
  def format_into_days(input_hash, test_key)
    output = "---"
    if input_hash.key?(test_key)
      output = sprintf('%.2f', input_hash[test_key] / 60 / 60 / 24)
    end
    return output
  end

  # Method to check for a key and format the number appropriately
  # This will be used for big integers (> 1000)
  def format_big_number(input_hash, test_key)
    output = "---"
    if input_hash.key?(test_key)
      output = ActiveSupport::NumberHelper.number_to_delimited(input_hash[test_key])
    end
    return output
  end

  # Method to prepare the full summary table.
  # Takes inputs of library_id (default is nil)
  # and fiscal_year (default is 2021)
  def prepare_summary_table(fiscal_year = 2021, library_id = nil,
    get_borrowing = false)

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
      output_row = [library_symbol, library_id]
      output_row << format_into_days(req_to_rec, library_id)
      output_row << format_into_days(req_to_shp, library_id)
      output_row << format_into_days(shp_to_rec, library_id)
      output_row << format_big_number(current_items, library_id)
      output_row << (fill_rate.key?(library_id) ?
        fill_rate[library_id] : "---")
      output_row << format_big_number(previous_items, library_id)

      # Loop through the monthly information
      display_months.each do |month|
        output_row << format_big_number(current_monthly_items,
          [library_id, month])
        output_row << format_big_number(previous_monthly_items,
          [library_id, month])
      end

      # Append this row to the output table
      output_table << output_row
    end

    return output_table, display_months

  end

end

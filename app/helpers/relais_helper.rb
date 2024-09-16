module RelaisHelper

  # Note: you have to restart the server to get access
  # to any changes in the helper methods!

  # Function to calculate the range of fiscal ranges for
  # the reshare model
  def relais_fiscal_year_range(model)
    # Find the maximum and minimum dates
    maximum_date = model::Relais::Bibliography.maximum(:request_date)
    minimum_date = model::Relais::Bibliography.minimum(:request_date)

    # Return if no range found
    if maximum_date.nil?
      return [nil]
    end

    # Find the starting and ending fiscal years
    maximum_fiscal_year = maximum_date.mon > 6 ?
      maximum_date.year + 1 : maximum_date.year
    minimum_fiscal_year = minimum_date.mon > 6 ?
      minimum_date.year + 1 : minimum_date.year

    # Make an array of possible years
    years = maximum_fiscal_year.downto(minimum_fiscal_year).to_a.map{
      |year| [year.to_s, year]
    }
    return years
  end

  # Function to display names of institutions
  def relais_institution_names(model, institution_ids)
    render_ids = []
    institution_ids.each do |id, amount|
      render_ids << [
        model::Relais::Institution.find_by(library_id: id).nil? ?
        "Not Supplied" :
        "#{model::Relais::Institution.find_by(library_id: id).institution_name} (#{id})",
        amount
      ]
    end
    return render_ids
  end

  def relais_library_name(model, library_id)
    if library_id.to_i < 0 or library_id.nil?
      return "All Libraries"
    end

    return model::Relais::Institution.find_by(library_id: library_id).nil? ?
             "Not supplied" :
             "#{model::Relais::Institution.find_by(library_id: library_id)
                                         .institution_name}"
  end

  # Create an array of arrays that map the library symbol to the library id
  def relais_library_map(model)
    library_map = []
    # Loop through all member institutions
    model::Relais::Institution.all.each do |lib|
      # Skip the "Default" case
      next if lib.library_id == 0
      # Skip the CRL, OCLC, OORII, and RapidILL cases
      next if [10000010, 9999997, 9999996, 9999995].include? lib.library_id
      library_map << [lib.library_symbol, lib.library_id]
    end
    # Return a sorted map
    return library_map.sort
  end

  # Method to construct the standard query to be used across all queries
  # Options for the initial query, the library_id (if given),
  # if the request is for borrowing or for the all libraries summary.
  def relais_base_query(input_query, options = {})

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
  def relais_count_library_items(model, this_year:, last_year:, library_id:, get_monthly:,
                             get_borrowing:, get_summary:)

    # Distinct request numbers in bibliography
    query = model::Relais::Bibliography.select(:request_number).distinct

    options = {
      :library_id => library_id,
      :get_monthly => get_monthly,
      :get_borrowing => get_borrowing,
      :get_summary => get_summary
    }

    # Construct standard query
    query = relais_base_query(query, **options)

    # Count all unique requests from this year and last year
    this_query = query.where(request_date: this_year).count
    last_query = query.where(request_date: last_year).count

    return this_query, last_query
  end

  # Function to combine the results of the queries for item counts
  def relais_count_items(model, options = {})

    # Returns a hash of library id to number
    this_by_library, last_by_library = relais_count_library_items(
      model,
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

  def relais_get_fill_rate(model, options = {})
    # Distinct request numbers in bibliography
    query = model::Relais::Bibliography.select(:request_number).distinct
    # Only want to know about the current year
    query = query.where(request_date: options[:this_year])

    # Returns a hash of library_id to number
    # Construct successful requests query
    successful_requests = relais_base_query(
      query,
      **options.merge(:get_successful => true)
    ).count
    # Construct all requests query
    all_requests = relais_base_query(
      query,
      **options.merge(:get_successful => false)
    ).count

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

  def relais_get_library_turnaround_time(model, options = {})
    # Get the table name prefix
    # Get the prefix of the table for the reshare model
    prefix = table_name_prefix(model::Relais)

    # Distinct request numbers in bibliography
    query = model::Relais::Bibliography
    # Only want to know about the current year
    query = query.where(request_date: options[:this_year])
    # Set up the base restrictions
    query = relais_base_query(query, **options)
    query = query.joins("INNER JOIN
      #{prefix}min_ship_dates AS ship
      ON #{prefix}bibliographies.request_number = ship.request_number")

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
  def relais_get_turnaround_time(model, options = {})
    by_library_req_to_rec, by_library_req_to_shp, by_library_shp_to_rec = relais_get_library_turnaround_time(
      model,
      **options.merge(:get_summary => false))
    all_libraries_req_to_rec, all_libraries_req_to_shp, all_libraries_shp_to_rec = relais_get_library_turnaround_time(
      model,
      **options.merge(:get_summary => true))

    # Add the all library counts to the hash
    by_library_req_to_rec.merge!(all_libraries_req_to_rec)
    by_library_req_to_shp.merge!(all_libraries_req_to_shp)
    by_library_shp_to_rec.merge!(all_libraries_shp_to_rec)

    return by_library_req_to_rec, by_library_req_to_shp, by_library_shp_to_rec
  end

  # Method to check for a key and format the number appropriately
  # This will be used for big integers (> 1000)
  def relais_format_into_days(input_hash, test_key)
    output = "---"
    if input_hash.key?(test_key)
      output = sprintf('%.2f', input_hash[test_key] / 60 / 60 / 24)
    end
    return output
  end

  # Method to check for a key and format the number appropriately
  # This will be used for big integers (> 1000)
  def relais_format_big_number(input_hash, test_key)
    output = "---"
    if input_hash.key?(test_key)
      output = ActiveSupport::NumberHelper.number_to_delimited(input_hash[test_key])
    end
    return output
  end

  # Method to prepare the full summary table.
  # Takes inputs of library_id (default is nil)
  # and fiscal_year (default is 2021)
  def relais_prepare_summary_table(model, fiscal_year = 2021, library_id = nil, get_borrowing = false)

    this_year, last_year = fiscal_year_ranges(fiscal_year)

    options = {
      :this_year => this_year,
      :last_year => last_year,
      :library_id => library_id,
      :get_monthly => false,
      :get_borrowing => get_borrowing
    }

    # Get the library turn around time
    req_to_rec, req_to_shp, shp_to_rec = relais_get_turnaround_time(model, **options)

    # Get the library fill rate
    fill_rate = relais_get_fill_rate(model, **options)

    # Get the yearly item count
    current_items, previous_items = relais_count_items(model, **options)

    # Get the monthly item counts (do this last!)
    options[:get_monthly] = true
    current_monthly_items, previous_monthly_items = relais_count_items(model, **options)

    # Get the list of months to dynamically display
    months = display_months(fiscal_year)

    # The the list of libraries
    library_map = [["All Libraries", -1]] + relais_library_map(model)

    # Prepare the output table for display
    output_table = []

    library_map.each do |library_symbol, library_id|
      # Get the library_name and library_id
      output_row = [library_symbol]
      output_row << relais_format_into_days(req_to_rec, library_id)
      output_row << relais_format_into_days(req_to_shp, library_id)
      output_row << relais_format_into_days(shp_to_rec, library_id)
      output_row << relais_format_big_number(current_items, library_id)
      output_row << (fill_rate.key?(library_id) ?
                       fill_rate[library_id] : "---")
      output_row << relais_format_big_number(previous_items, library_id)

      # Loop through the monthly information
      months.each do |month|
        output_row << relais_format_big_number(current_monthly_items,
                                        [library_id, month])
        output_row << relais_format_big_number(previous_monthly_items,
                                        [library_id, month])
      end

      # Append this row to the output table
      output_table << output_row
    end

    return output_table, months

  end

end

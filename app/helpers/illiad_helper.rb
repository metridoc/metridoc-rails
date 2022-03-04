module IlliadHelper
  def display_names_ill(institution_ids)
    render_ids = {}
    institution_ids.each do |id, amount|
      render_ids[Institution.find_by(id: id).nil? ?
        "Not supplied" : Institution.find_by(id: id).name] = amount
    end
    return render_ids
  end

  # Locations of the start date of the request
  TURNAROUND_START_DATE = {
    "Borrowing" => "request_date",
    "Lending" => "arrival_date",
    "Doc Del" => "arrival_date"
  }

  # Locations of completion date
  TURNAROUND_COMPLETION_DATE =
  {
    "Borrowing" => "receive_date",
    "Lending" => "completion_date",
    "Doc Del" => "completion_date"
  }

  # Locations of calculated turnaround times
  TURNAROUND_TIMES =
  {
    "Borrowing" => "turnaround_req_rec",
    "Lending" => "turnaround",
    "Doc Del" => "turnaround"
  }

  # A FILLED status is not in UNFILLED_STATUS or PENDING_STATUS
  # Define what a unfilled status is for all types
  UNFILLED_STATUS = "Cancelled by ILL Staff"

  # Define what a pending status is for all types
  PENDING_STATUS = "NULL"

  # Function uses a process type to determine which Tracking
  # table to access then collects all the statistics information
  # in a nested SQL statement
  def count_requests(process_type, year, options={})
    # Select the table
    case process_type
    when "Borrowing"
      table = Illiad::Tracking
    when "Lending"
      table = Illiad::LendingTracking
    when "Doc Del"
      table = Illiad::DocDelTracking
    else
      table = nil
    end

    # Group by month
    get_monthly = options.fetch(:get_monthly, false)

    # Group by lender groups
    group_by_user = options.fetch(:group_by_user, false)

    # Set up the default conditions
    library_id = options.fetch(:library_id, 2)

    # Get the name of the table
    table_name = table.table_name

    # Create a subquery for further calculations
    # This will count the total requests,
    # the filled requests, the unfilled requests,
    # and the pending requests in the specified
    # fiscal year for the specified institution
    # and group by the request type
    from_sql = table.select(:request_type)
      .select("COUNT(DISTINCT #{table_name}.transaction_number) AS total_requests")
      .select("COUNT(
        CASE WHEN
          NOT #{table_name}.completion_status = '#{UNFILLED_STATUS}'
          AND #{table_name}.completion_status IS NOT #{PENDING_STATUS}
        THEN 1
        END) AS filled_requests")
      .select("COUNT(
        CASE WHEN
          #{table_name}.completion_status = '#{UNFILLED_STATUS}'
        THEN 1
        END) AS unfilled_requests")
      .select("COUNT(
        CASE WHEN
          #{table_name}.completion_status IS #{PENDING_STATUS}
        THEN 1
        END) AS pending_requests")
      .select("AVG(
        CASE WHEN
          NOT #{table_name}.completion_status = '#{UNFILLED_STATUS}'
          AND #{table_name}.completion_status IS NOT #{PENDING_STATUS}
        THEN #{TURNAROUND_TIMES[process_type]}
        END) AS turnaround")
      .where(institution_id: library_id)
      .where("#{TURNAROUND_START_DATE[process_type]} BETWEEN '#{year.begin}' AND '#{year.end}'")

      # Documentation in case billing will be added
      # Calculate the billed amount
      # UPenn uses ifm cost for internal lending
      # Other institutions may use billing_amount
      # if process_type = 'Lending'
      #   from_sql = from_sql.select(
      #     "SUM(
      #       CAST(
      #         illiad_transactions.billing_amount AS DOUBLE PRECISION
      #       )
      #     ) AS billing_amount"
      #   )
      # else
      #   from_sql = from_sql.select(
      #     "SUM(
      #       CAST(
      #         SUBSTRING( illiad_transactions.ifm_cost, 2) AS DOUBLE PRECISION
      #       )
      #     ) AS billing_amount"
      #   )
      # end

    # Group by month when requested
    if get_monthly
      from_sql = from_sql.select(
        "CAST(EXTRACT (MONTH FROM #{TURNAROUND_START_DATE[process_type]}) AS int) AS month"
      ).group("month")
    end

    # Group by lender groups when requested
    if group_by_user
      from_sql = from_sql.select("illiad_groups.group_name AS group_name")
        .joins("LEFT JOIN illiad_transactions " +
          "ON illiad_transactions.transaction_number = #{table_name}.transaction_number " +
          "AND illiad_transactions.institution_id = #{table_name}.institution_id")
        .joins("LEFT JOIN illiad_lender_groups " +
          "ON illiad_transactions.lending_library = illiad_lender_groups.lender_code " +
          "AND illiad_transactions.institution_id = illiad_lender_groups.institution_id")
        .joins("LEFT JOIN illiad_groups " +
          "ON illiad_lender_groups.group_no = illiad_groups.group_no " +
          "AND illiad_lender_groups.institution_id = illiad_groups.institution_id"
      ).group("group_name")
    end

    # Group by request type
    from_sql = from_sql.group(:request_type).to_sql

    # Run further calculations based on subquery
    query = table.select(
      "'#{process_type}' AS process_type",
      "request_type",
      "'FY#{year.begin.year + 1}' AS fiscal_year",
      "total_requests",
      "filled_requests",
      "filled_requests::float / total_requests AS filled_rate",
      "unfilled_requests",
      "unfilled_requests::float / total_requests AS unfilled_rate",
      "pending_requests",
      "turnaround"
    )

    # Select month when requested
    query = get_monthly ? query.select("month") : query

    # Select lender group when requested
    query = group_by_user ? query.select("group_name") : query

    # Run the query and return a json format
    query = query.from("(#{from_sql}) AS counts").all.as_json

    return query

  end

  # Calculate the completion rate
  def query_statistics(year, options = {})

    # Set up the default conditions
    library_id = options.fetch(:library_id, 2)

    # Set up the default conditions
    get_monthly = options.fetch(:get_monthly, false)

    # Group by lender groups
    group_by_user = options.fetch(:group_by_user, false)

    # For each process type load the results into an array
    results = []
    process_types.keys.each do |process_type|
      results = results + count_requests(process_type.to_s, year, options)
    end

    # Product will combine lists
    # Get a list of all keys needed for tables
    output_keys = process_types.keys.map{ |k| k.to_s }.product(
      request_types.keys.map{ |k| k.to_s }
    )

    # Build keys for the monthly tables
    if get_monthly
      months = display_months(year)
      output_keys = process_types.keys.map{ |k| k.to_s }.product(
        request_types.keys.map{ |k| k.to_s },
        months
      )
    end

    # Build keys for grouping by user tables
    if group_by_user
      groups = lender_groups(library_id)
      output_keys = process_types.keys.map{ |k| k.to_s }.product(
        request_types.keys.map{ |k| k.to_s },
        groups
      )
    end

    # Return a hash of the request_type and process_type
    # as keys to the related row.
    output = {}
    # Loop through the results
    results.each do |r|
      key = [r["process_type"], r["request_type"]]

      # Append to key the month
      if get_monthly
        key.append(r["month"])
      end

      # Append to key the group
      if group_by_user
        key.append(r["group_name"])
      end

      # Create the values to enter into the table
      # and format them appropriately
      value = [
        r["fiscal_year"],
        format_big_number(r["total_requests"]),
        format_big_number(r["filled_requests"]),
        format_percent(r["filled_rate"]),
        format_big_number(r["unfilled_requests"]),
        format_percent(r["unfilled_rate"]),
        format_big_number(r["pending_requests"]),
        format_into_days(r["turnaround"]),
        #format_currency(billing.fetch(key, 0))
      ]

      # Remove the fiscal year for sub pages
      if get_monthly or group_by_user
        value = value.drop(1)
      end

      output[key] = value
    end

    # The length of the value is variable depending on the request made
    value_length = output.values.first.length()

    # Fill in default for missing keys
    output_keys.each do |key|
      unless output.key?(key)
        value = Array.new(value_length) {"---"}
        output[key] = value
      end
    end

    return output
  end

  # Returns an array of possible groups
  def lender_groups(library_id)
    # Find distinct transactions
    all_groups = Illiad::Group.select(
      :group_name
    ).distinct.where(
      institution_id: library_id
    )
    groups = []
    all_groups.each do |group|
      groups.append(group.group_name)
    end
    # Adding special case for group by to nil
    return groups.sort.append(nil)
  end

  # Format the number of days to 2 decimal places
  def format_into_days(input)
    output = "---"
    if input and input != 0 and not input.to_f.nan?
      output = sprintf('%.2f', input)
    end
    return output
  end

  # Method to format the number appropriately
  # This will be used for big integers (> 1000)
  def format_big_number(input)
    output = "---"
    if input and input != 0
      output = ActiveSupport::NumberHelper.number_to_delimited(input)
    end
    return output
  end

  # Method to format the number appropriately
  # This will be used for percentages
  def format_percent(input)
    output = "---"
    if input and input != 0 and not input.to_f.nan?
      output = ActiveSupport::NumberHelper.number_to_percentage(
        input * 100, precision: 1
      )
    end
    return output
  end

  # Mapping of process types to proper titles
  def process_types
    {
      "Borrowing": "Borrowing",
      "Lending": "Lending",
      "Doc Del": "Document Delivery"
    }
  end

  # Mapping of request types to proper titles
  def request_types
    {
      "Article": "Articles",
      "Loan": "Books"
    }
  end

  # Method to check for a key and format the number appropriately
  # This will be used for big integers (> 1000)
  def format_currency(input)
    output = "---"
    if input and input != 0
      output = ActiveSupport::NumberHelper.number_to_currency(input)
    end
    return output
  end

  # Method to build the overall statistical summary table
  def build_summary_table(fiscal_year, library_id)
    years = fiscal_year_ranges(fiscal_year)

    options = {
      :library_id => library_id
    }

    output_table = {}

    # Construct the output hash for the table
    years.each do |year|
      year_table = query_statistics(year, **options)
      year_table.each do |k, v|
        # If the key exists, append to the end
        if output_table.key?(k)
          output_table[k] = output_table[k].append(v)
        # if the key doesn't exist, make a list of lists
        else
          output_table[k] = [v]
        end
      end
    end

    return output_table
  end

  # Method to build the monthly breakdown table
  def build_monthly_table(fiscal_year, library_id)
    this_year, last_year = fiscal_year_ranges(fiscal_year)

    options = {
      :library_id => library_id,
      :get_monthly => true
    }

    # Construct an output hash for the table
    output_table = query_statistics(this_year, **options)

    return output_table, display_months(this_year)
  end

  # Method to access user groups
  def build_user_table(fiscal_year, library_id)
    this_year, last_year = fiscal_year_ranges(fiscal_year)

    options = {
      :library_id => library_id,
      :group_by_user => true
    }

    # Construct an output hash for the table
    output_table = query_statistics(this_year, **options)

    return output_table, lender_groups(library_id)
  end

end

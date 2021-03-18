module IlliadHelper
  def display_names_ill(institution_ids)
    render_ids = {}
    institution_ids.each do |id, amount|
      render_ids[Institution.find_by(id: id).nil? ?
        "Not supplied" : Institution.find_by(id: id).name] = amount
    end
    return render_ids
  end

  # Define what the turnaround status is for all types
  TURNAROUND_STATUS =
  {
    "Borrowing" =>
    {
      "Article" => "Delivered to Web",
      "Loan" => "Awaiting Post Receipt Processing"
    },
    "Lending" =>
    {
      # Penn provides request to online portal
      "Article" => "Request Finished",
      "Loan" => "Item Shipped"
    },
    "Doc Del" =>
    {
      "Article" => "Delivered to Web",
      "Loan" => "Item Found"
    }
  }

  # Define what a successful status is for all types
  TURNAROUND_STATUS_TABLES =
  {
    "Borrowing" => "illiad_borrowings.transaction_status",
    "Lending" => "illiad_lendings.status",
    # Doc Del doesn't have tracking information stored in metridoc
    # TODO: Add Doc Del tracking table
    "Doc Del" => "illiad_transactions.transaction_status"
  }

  # Define what a successful status is for all types
  TURNAROUND_DATE_TABLES =
  {
    "Borrowing" => "illiad_borrowings.transaction_date",
    "Lending" => "illiad_lendings.transaction_date",
    "Doc Del" => "illiad_transactions.transaction_date"
  }

  # Calculate the turnaround times
  def find_turnaround(query, options = {})
    # Example Query:
    # SELECT
    #  AVG(EXTRACT(epoch FROM illiad_lendings.transaction_date - illiad_transactions.creation_date))
    # FROM illiad_transactions
    # LEFT JOIN illiad_lendings
    #  ON illiad_transactions.transaction_number = illiad_lendings.transaction_number
    #  AND illiad_transactions.institution_id = illiad_lendings.institution_id
    # WHERE illiad_transactions.institution_id = 2
    #  AND illiad_lendings.status = 'Item Shipped';

    filter_statement = "CASE "
    turnaround_calculation = "CASE "
    # Loop through process types
    process_types.each do |p_k, p_v|
      # Loop through request types
      request_types.each do |r_k, r_v|
        prefix = ("WHEN illiad_transactions.process_type = '" + p_k.to_s + "'" +
          " AND illiad_transactions.request_type = '" + r_k.to_s + "'"
        )

        filter_statement = (
          filter_statement + prefix +
          " THEN " + TURNAROUND_STATUS_TABLES[p_k.to_s] + " = '" + TURNAROUND_STATUS[p_k.to_s][r_k.to_s] + "' "
        )

        turnaround_calculation = (
          turnaround_calculation + prefix +
          " THEN EXTRACT (epoch FROM " + TURNAROUND_DATE_TABLES[p_k.to_s] + " - illiad_transactions.creation_date) "
        )

      end
    end

    filter_statement = filter_statement + " END"
    turnaround_calculation = turnaround_calculation + " END"

    turnaround = base_query(
      query,
      **options.merge(:only_filled => true)
    ).joins(
      "LEFT JOIN illiad_lendings " +
      "ON illiad_transactions.transaction_number = illiad_lendings.transaction_number " +
      "AND illiad_transactions.institution_id = illiad_lendings.institution_id"
    ).joins(
      "LEFT JOIN illiad_borrowings " +
      "ON illiad_transactions.transaction_number = illiad_borrowings.transaction_number " +
      "AND illiad_transactions.institution_id = illiad_borrowings.institution_id"
    ).where(
      filter_statement
    ).average(
      turnaround_calculation
    )

    return turnaround

  end

  # Define what a successful status is for all types
  COMPLETED_STATUS =
  {
    "Borrowing" =>
    {
      "Article" => [
        # Available to user to retrieve?
        "Delivered to Web",
        # A 30 day padding to the end of the request
        "Request Finished"
      ],
      "Loan" => [
        "Delivered to Web",
        # Loan has been returned lending institution
        "Request Finished",
        # Loan has been received by Penn
        "Awaiting Post Receipt Processing",
        # Customer has Loan
        "Checked Out to Customer"
      ]
    },
    "Lending" =>
    {
      # Penn provides request to online portal
      "Article" => ["Request Finished"],
      "Loan" => [
        # Loan returned to Penn
        "Request Finished",
        # Loan set out from Penn
        "Item Shipped"
      ]
    },
    "Doc Del" =>
    {
      "Article" => [
        # Available to user
        "Delivered to Web",
        # With a 30 day padding to mark as complete
        "Request Finished"
      ],
      "Loan" => [
        # Item found then taken to pick up location
        "Item Found",
        # Request completed and picked up or shipped
        "Request Finished",
        # Loans rerouted from DocDel to Borrowing
        # Do not have "Item Found" in History
        "Request Sent"
      ]
    }
  }

  # Define what a failed status is for all types
  FAILED_STATUS = ["Cancelled by ILL Staff"]

  # Method to construct the standard query to be used across all queries
  def base_query(input_query, options = {})

    # Set up the default conditions
    library_id = options.fetch(:library_id, 2)

    # Group by months
    get_monthly = options.fetch(:get_monthly, false)

    # Group by lender groups
    group_by_user = options.fetch(:group_by_user, false)

    # Filter only filled or exhausted records
    only_filled = options.fetch(:only_filled, false)
    only_exhausted = options.fetch(:only_exhausted, false)

    # Find Penn only transactions
    output_query = input_query.where(institution_id: library_id)

    # Group the result by the request and process types
    # Group by the process type:
    # Borrowing, Lending, or Doc Del (internal)
    output_query = output_query.group(:process_type)
    # Group by the request type:
    # Article or Loan (book)
    output_query = output_query.group(:request_type)

    # Select only successfully completed records
    if only_filled
      # Complicated CASE statement needed to be able
      # to group by process_type and request_type
      case_statement = "CASE "
      # Loop through process types
      process_types.each do |p_k, p_v|
        # Loop through request types
        request_types.each do |r_k, r_v|
          case_statement = (
            case_statement +
            "WHEN illiad_transactions.process_type = '" + p_k.to_s + "'" +
            " AND illiad_transactions.request_type = '" + r_k.to_s + "'" +
            " THEN illiad_transactions.transaction_status IN (" +
            # Hacky way to get 'value', 'value',...
            "'#{COMPLETED_STATUS[p_k.to_s][r_k.to_s].join("', '")}'" + ") "
          )
        end
      end
      case_statement = case_statement + " END"

      output_query = output_query.where(
        case_statement
      )
    end

    # Select only exhausted (permanently unfilled) records
    output_query = only_exhausted ?
    output_query.where(
      transaction_status: FAILED_STATUS
      ) : output_query

    # Group by month when requested
    output_query = get_monthly ?
    output_query.group(
      "CAST(EXTRACT (MONTH FROM creation_date) AS int)"
      ) : output_query

    # Group by lender groups
    if group_by_user
      output_query = output_query.joins(
        "LEFT JOIN illiad_lender_groups " +
        "ON illiad_transactions.lending_library = illiad_lender_groups.lender_code " +
        "AND illiad_transactions.institution_id = illiad_lender_groups.institution_id"
      ).joins(
        "LEFT JOIN illiad_groups " +
        "ON illiad_lender_groups.group_no = illiad_groups.group_no " +
        "AND illiad_lender_groups.institution_id = illiad_groups.institution_id"
      ).group("illiad_groups.group_name")
    end

    return output_query
  end

  # Calculate the completion rate
  def query_statistics(year, options = {})

    # Set up the default conditions
    library_id = options.fetch(:library_id, 2)

    # Set up the default conditions
    get_monthly = options.fetch(:get_monthly, false)

    # Group by lender groups
    group_by_user = options.fetch(:group_by_user, false)

    # Find distinct transactions
    query = Illiad::Transaction.select(
      :transaction_number
    ).distinct
    # Restrict to this year
    query = query.where(creation_date: year)

    turnaround = find_turnaround(
      query,
      **options.merge(:only_filled => true)
    )

    # Find the number of successful requests
    successful_requests = base_query(
      query,
      **options.merge(:only_filled => true)
    ).count

    # Find the number of failed requests
    failed_requests = base_query(
      query,
      **options.merge(:only_exhausted => true)
    ).count

    # Set the basic query for the remaining calls
    query = base_query(query, **options)

    # Find the total number of requests
    total_requests = query.count

    # Calculate the billed amount
    # UPenn uses ifm cost for internal lending
    # Other institutions may use billing_amount
    # Complicated CASE statement needed to be able
    # to group by process_type
    # case_statement = (
    #   "CASE " +
    #   "WHEN process_type = 'Borrowing' " +
    #   "THEN CAST (SUBSTRING(ifm_cost, 2) AS DOUBLE PRECISION) " +
    #   "WHEN process_type = 'Doc Del' " +
    #   "THEN CAST (SUBSTRING(ifm_cost, 2) AS DOUBLE PRECISION) " +
    #   "WHEN process_type = 'Lending' " +
    #   "THEN CAST (billing_amount AS DOUBLE PRECISION) " +
    #   "END"
    # )
    # billing = query.sum(case_statement)

    # Product will combine lists
    output_keys = process_types.keys.map{ |k| k.to_s }.product(
      request_types.keys.map{ |k| k.to_s }
    )

    # Build keys for the monthly situation
    if get_monthly
      months = display_months(year)
      output_keys = process_types.keys.map{ |k| k.to_s }.product(
        request_types.keys.map{ |k| k.to_s },
        months
      )
    end

    # Build keys for grouping by user
    if group_by_user
      # Find distinct transactions
      groups = lender_groups(library_id)

      output_keys = process_types.keys.map{ |k| k.to_s }.product(
        request_types.keys.map{ |k| k.to_s },
        groups
      )
    end

    # Return a hash of the request_type and process_type
    # as keys to the related row.
    output = {}
    # Loop through the output keys
    output_keys.each do |key|
      total = total_requests.fetch(key, 0)
      successful = successful_requests.fetch(key, 0)
      failed = failed_requests.fetch(key, 0)
      output[key] = [
        format_big_number(total),
        format_big_number(successful),
        format_percent(successful.fdiv(total)),
        format_big_number(failed),
        format_percent(failed.fdiv(total)),
        format_big_number(total - successful - failed),
        format_into_days(turnaround.fetch(key, 0)),
        #format_currency(billing.fetch(key, 0))
      ]
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

  # Turn a time difference in seconds into days
  def format_into_days(input)
    output = "---"
    if input and input != 0 and not input.to_f.nan?
      output = sprintf('%.2f', input / 60 / 60 / 24)
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
      "Doc Del": "Internal"
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
          output_table[k] = output_table[k].append(
            ["FY" + (year.min.year + 1).to_s] + v
          )
        # if the key doesn't exist, make a list of lists
        else
          output_table[k] = [["FY" + (year.min.year + 1).to_s] + v]
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

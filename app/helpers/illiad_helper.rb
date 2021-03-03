module IlliadHelper
  def display_names_ill(institution_ids)
    render_ids = {}
    institution_ids.each do |id, amount|
      render_ids[Institution.find_by(id: id).nil? ?
        "Not supplied" : Institution.find_by(id: id).name] = amount
    end
    return render_ids
  end

  # Calculate the turnaround times
  def turnaround()

  end

  # Define what a successful status is for all types
  COMPLETED_STATUS =
  {
    "Borrowing" =>
    {
      "Article" => [
        "Delivered to Web",
        "Request Finished",
        "Request Sent"
      ],
      "Loan" => [
        "Delivered to Web",
        "Request Finished",
        "Awaiting Post Receipt Processing",
        "Checked Out to Customer"
      ]
    },
    "Lending" =>
    {
      "Article" => ["Request Finished"],
      "Loan" => [
        "Request Finished",
        "Item Shipped"
      ]
    },
    "Doc Del" =>
    {
      "Article" => [
        "Delivered to Web",
        "Request Finished"
      ],
      "Loan" => [
        "Item Found",
        "Request Finished",
        "Reqeust Sent"
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
            "WHEN process_type = '" + p_k.to_s + "'" +
            " AND request_type = '" + r_k.to_s + "'" +
            " THEN transaction_status IN (" +
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

    # Select only exhausted (permantently unfilled) records
    output_query = only_exhausted ?
    output_query.where(
      transaction_status: FAILED_STATUS
      ) : output_query

    # Group by month when requested
    output_query = get_monthly ?
    output_query.group(
      "CAST(EXTRACT (MONTH FROM creation_date) AS int)"
      ) : output_query

    return output_query
  end

  # Calculate the completion rate
  def query_statistics(year, options = {})

    # Set up the default conditions
    get_monthly = options.fetch(:get_monthly, false)

    # Find distinct transactions
    query = Illiad::Transaction.select(
      :transaction_number
    ).distinct
    # Restrict to this year
    query = query.where(creation_date: year)

    turnaround = base_query(
      query,
      **options.merge(:only_filled => true)
    ).average("EXTRACT (epoch FROM transaction_date - creation_date)")

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
    case_statement = (
      "CASE " +
      "WHEN process_type = 'Borrowing' " +
      "THEN CAST (SUBSTRING(ifm_cost, 2) AS DOUBLE PRECISION) " +
      "WHEN process_type = 'Doc Del' " +
      "THEN CAST (SUBSTRING(ifm_cost, 2) AS DOUBLE PRECISION) " +
      "WHEN process_type = 'Lending' " +
      "THEN CAST (billing_amount AS DOUBLE PRECISION) " +
      "END"
    )
    billing = query.sum(case_statement)

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
        format_currency(billing.fetch(key, 0))
      ]
    end

    return output
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

end

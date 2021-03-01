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
    process_type = options.fetch(:process_type, "Borrowing")
    request_type = options.fetch(:request_type, "Loan")

    # Group by months
    get_monthly = options.fetch(:get_monthly, false)

    # Filter only filled or exhausted records
    only_filled = options.fetch(:only_filled, false)
    only_exhausted = options.fetch(:only_exhausted, false)

    # Find Penn only transactions
    output_query = input_query.where(institution_id: library_id)
    # Define the process type:
    # Borrowing, Lending, or Doc Del (internal)
    output_query = output_query.where(process_type: process_type)
    # Define the request type:
    # Article or Loan (book)
    output_query = output_query.where(request_type: request_type)

    # Select only successfully completed records
    output_query = only_filled ?
    output_query.where(
      transaction_status: COMPLETED_STATUS[process_type][request_type]
      ) : output_query

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
    library_id = options.fetch(:library_id, 2)
    process_type = options.fetch(:process_type, "Borrowing")
    request_type = options.fetch(:request_type, "Loan")

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

    # Join transactions to the trackings table on successful requests
    # To find the turnaround statistics
    # illiad_trackings is only for borrowing not for lending or doc del!
    #turnaround_query = base_query(
    #  query,
    #  **options.merge(:only_filled => true)
    #).joins(
    #  "LEFT JOIN illiad_trackings
    #  ON illiad_trackings.transaction_number = illiad_transactions.transaction_number
    #  AND illiad_trackings.institution_id = illiad_transactions.institution_id"
    #)

    # Get the average turnaround times
    #req_rec = turnaround_query.average(:turnaround_req_rec)
    #req_shp = turnaround_query.average(:turnaround_req_shp)
    #shp_rec = turnaround_query.average(:turnaround_shp_rec)

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
    billing = 0
    # UPenn uses ifm cost for internal lending
    # Other instituions may use billing_amount
    if process_type == "Borrowing" or process_type == "Doc Del"
      billing = query.sum(
        "CAST (SUBSTRING(ifm_cost, 2) AS DOUBLE PRECISION)"
      )
    elsif process_type == "Lending"
      billing = query.sum(
        "CAST (billing_amount AS DOUBLE PRECISION)"
      )
    else
      billing = 0
    end

    # Return everything in one huge list!
    return [
      format_big_number(total_requests),
      format_big_number(successful_requests),
      format_percent(successful_requests.fdiv(total_requests)),
      format_big_number(failed_requests),
      format_percent(failed_requests.fdiv(total_requests)),
      format_big_number(total_requests - successful_requests - failed_requests),
      format_into_days(turnaround),
      format_currency(billing)
    ]
  end

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

  def build_summary_table(fiscal_year, library_id)
    years = fiscal_year_ranges(fiscal_year)

    options = {
      :library_id => library_id
    }

    # Construct an output hash for the table
    output_table = {}

    # Loop through all processes and requests and years
    process_types.keys.each do |process|
      # Convert key type to string
      process = process.to_s
      if not output_table.has_key?(process)
        output_table[process] = {}
      end
      request_types.keys.each do |request|
        # Convert key type to string
        request = request.to_s
        if not output_table[process].has_key?(request)
          output_table[process][request] = []
        end
        years.each do |year|
          output_table[process][request].append(
            ["FY" + (year.min.year + 1).to_s] +
            (query_statistics(year,
              **options.merge(
                {
                  :process_type => process,
                  :request_type => request
                }
              ))
            )
          )
        end
      end
    end
    return output_table
  end

end

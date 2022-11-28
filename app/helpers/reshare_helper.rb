module ReshareHelper

  # Function to calculate the range of fiscal ranges for
  # the reshare model
  def reshare_fiscal_year_range(model)
    # Find the maximum and minimum dates
    maximum_date = model::Reshare::Transaction.maximum(:date_created)
    minimum_date = model::Reshare::Transaction.minimum(:date_created)

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


  # Create an array of library names
  def reshare_institution_names(model)
    # Get unique names where the parent is null
    model::Reshare::DirectoryEntry.select(:de_name)
    .where(de_parent: nil)
    .where.not(de_name: 'Ivy Plus Libraries Confederation')
    .group(:de_name)
    .order(:de_name)
    .count
    .keys
  end

  # Calculate the total lending for the selected institution
  # Order of results are Total, Complete, Unfilled, Cancelled, Pending
  def reshare_lending_summary(model, institution, fiscal_year)

    # Get the prefix of the table for the reshare model
    prefix = table_name_prefix(model::Reshare)

    # Get the rollup of lending attempts
    model::Reshare::Transaction.connection.select_all(
      "SELECT
         COALESCE(
           #{prefix}transactions.borrower, 'All Institutions'
         ) AS borrower,
         COUNT(DISTINCT #{prefix}transactions.request_id) AS total_requests,
         COUNT(DISTINCT #{prefix}transactions.request_id) FILTER (
           WHERE #{prefix}transactions.lender_status = 'RES_COMPLETE'
         ) AS complete,
         COUNT(DISTINCT #{prefix}transactions.request_id) FILTER (
           WHERE #{prefix}transactions.lender_status = 'RES_UNFILLED'
         ) as unfilled,
         COUNT(DISTINCT #{prefix}transactions.request_id) FILTER (
           WHERE #{prefix}transactions.lender_status = 'RES_CANCELLED'
         ) AS cancelled,
         COUNT(DISTINCT #{prefix}transactions.request_id) FILTER (
           WHERE #{prefix}transactions.lender_status NOT IN (
             'RES_UNFILLED', 'RES_COMPLETE', 'RES_CANCELLED'
           )
         ) AS pending,
         ROUND(
           CAST(
             COUNT(DISTINCT #{prefix}transactions.request_id) FILTER (
               WHERE #{prefix}transactions.lender_status = 'RES_COMPLETE'
             ) AS DECIMAL
           ) / NULLIF(
             CAST(
               COUNT(DISTINCT #{prefix}transactions.request_id) FILTER (
                 WHERE #{prefix}transactions.lender_status IN (
                   'RES_COMPLETE', 'RES_UNFILLED', 'RES_CANCELLED'
                 )
               ) AS DECIMAL
             ), 0
           ), 2
         ) AS fill_rate,
         ROUND(AVG(#{prefix}lending_turnarounds.time_to_fill) FILTER (
           WHERE #{prefix}transactions.lender_status != 'RES_UNFILLED'
         ), 2) AS average_time_to_fill,
         ROUND(AVG(#{prefix}lending_turnarounds.time_to_ship) FILTER (
           WHERE #{prefix}transactions.lender_status != 'RES_UNFILLED'
         ), 2) AS average_time_to_ship,
         ROUND(AVG(#{prefix}lending_turnarounds.time_to_receipt) FILTER (
           WHERE #{prefix}transactions.lender_status != 'RES_UNFILLED'
         ), 2) AS average_time_to_receipt,
         ROUND(AVG(#{prefix}lending_turnarounds.total_time) FILTER (
           WHERE #{prefix}transactions.lender_status != 'RES_UNFILLED'
         ), 2) AS average_turnaround
       FROM #{prefix}transactions
       LEFT JOIN #{prefix}lending_turnarounds
       ON #{prefix}lending_turnarounds.request_id = #{prefix}transactions.lender_id
       WHERE #{prefix}transactions.lender = '#{institution}'
       AND #{prefix}transactions.date_created
         BETWEEN '#{fiscal_year-1}-07-01' AND '#{fiscal_year}-06-30'
       GROUP BY ROLLUP (borrower)
       ORDER BY borrower NULLS FIRST;"
    ).rows
  end

  # Build the summary table for the selected institution
  # Order of results are Lender, Total, Completed, Unfilled,
  # Cancelled, Pending, Average Time to Ship, Average Time to Receipt,
  # Average Total Time
  def reshare_borrowing_summary(model, institution, fiscal_year)
    # Get the prefix of the table for the reshare model
    prefix = table_name_prefix(model::Reshare)

    # Borrowing total summary is based on the borrower's status.
    summary_row = model::Reshare::Transaction.connection.select_all(
      "SELECT
        'All Institutions' AS lender,
        COUNT(
          DISTINCT #{prefix}transactions.request_id
        ) AS total_requests,
        COUNT(
          DISTINCT #{prefix}transactions.request_id
        ) FILTER (
          WHERE #{prefix}transactions.borrower_status = 'REQ_REQUEST_COMPLETE'
        ) AS complete,
        COUNT(
          DISTINCT #{prefix}transactions.request_id
        ) FILTER (
          WHERE #{prefix}transactions.borrower_status = 'REQ_END_OF_ROTA'
        ) AS unfilled,
        COUNT(
          DISTINCT #{prefix}transactions.request_id
        ) FILTER (
          WHERE #{prefix}transactions.borrower_status IN (
            'REQ_CANCELLED', 'REQ_CANCEL_PENDING'
          )
        ) AS cancelled,
        COUNT(
          DISTINCT #{prefix}transactions.request_id
        ) FILTER (
          WHERE #{prefix}transactions.borrower_status NOT IN (
            'REQ_REQUEST_COMPLETE', 'REQ_END_OF_ROTA', 'REQ_CANCELLED', 'REQ_CANCEL_PENDING'
          )
        ) AS pending,
        ROUND(
          CAST(
            COUNT(DISTINCT #{prefix}transactions.request_id) FILTER (
              WHERE #{prefix}transactions.borrower_status = 'REQ_REQUEST_COMPLETE'
            ) AS DECIMAL
          ) / NULLIF(
            CAST(
              COUNT(DISTINCT #{prefix}transactions.request_id) FILTER (
                WHERE #{prefix}transactions.borrower_status IN (
                  'REQ_REQUEST_COMPLETE', 'REQ_END_OF_ROTA',
                  'REQ_CANCELLED', 'REQ_CANCEL_PENDING'
                )
              ) AS DECIMAL
            ), 0
          ), 2
        ) AS fill_rate,
        ROUND(AVG(#{prefix}borrowing_turnarounds.time_to_ship) FILTER (
          WHERE #{prefix}transactions.lender_status != 'RES_UNFILLED'
        ), 2) AS average_time_to_ship,
        ROUND(AVG(#{prefix}borrowing_turnarounds.time_to_receipt) FILTER (
          WHERE #{prefix}transactions.lender_status != 'RES_UNFILLED'
        ), 2) AS average_time_to_receipt,
        ROUND(AVG(#{prefix}borrowing_turnarounds.total_time) FILTER (
          WHERE #{prefix}transactions.lender_status != 'RES_UNFILLED'
        ), 2) AS average_turnaround
      FROM #{prefix}transactions
      LEFT JOIN #{prefix}borrowing_turnarounds
      ON #{prefix}borrowing_turnarounds.request_id = #{prefix}transactions.borrower_id
      WHERE #{prefix}transactions.borrower = '#{institution}'
      AND #{prefix}transactions.date_created
        BETWEEN '#{fiscal_year-1}-07-01' AND '#{fiscal_year}-06-30';"
    ).rows

    # Fetch the summary rows by institution.
    # Logic is different to get accurate counts of how a lender interacts with
    # a borrower's request.
    institution_rows = model::Reshare::Transaction.connection.select_all(
      "SELECT
        #{prefix}transactions.lender,
        COUNT(
          DISTINCT #{prefix}transactions.request_id
        ) AS total_requests,
        COUNT(DISTINCT #{prefix}transactions.request_id) FILTER (
          WHERE #{prefix}transactions.lender_status = 'RES_COMPLETE'
        ) AS complete,
        COUNT(DISTINCT #{prefix}transactions.request_id) FILTER (
          WHERE #{prefix}transactions.lender_status = 'RES_UNFILLED'
        ) AS unfilled,
        COUNT(DISTINCT #{prefix}transactions.request_id) FILTER (
          WHERE #{prefix}transactions.lender_status = 'RES_CANCELLED'
        ) AS cancelled,
        COUNT(DISTINCT #{prefix}transactions.request_id) FILTER (
          WHERE #{prefix}transactions.lender_status NOT IN (
            'RES_COMPLETE', 'RES_UNFILLED', 'RES_CANCELLED'
          )
        ) AS pending,
        ROUND(
          CAST(
            COUNT(DISTINCT #{prefix}transactions.request_id) FILTER (
              WHERE #{prefix}transactions.lender_status = 'RES_COMPLETE'
            ) AS DECIMAL
          ) / NULLIF(
            CAST(
              COUNT(DISTINCT #{prefix}transactions.request_id) FILTER (
                WHERE #{prefix}transactions.lender_status IN (
                  'RES_COMPLETE', 'RES_UNFILLED', 'RES_CANCELLED'
                )
              ) AS DECIMAL
            ), 0
          ), 2
        ) AS fill_rate,
        ROUND(AVG(#{prefix}borrowing_turnarounds.time_to_ship) FILTER (
          WHERE #{prefix}transactions.lender_status != 'RES_UNFILLED'
        ), 2) AS average_time_to_ship,
        ROUND(AVG(#{prefix}borrowing_turnarounds.time_to_receipt) FILTER (
          WHERE #{prefix}transactions.lender_status != 'RES_UNFILLED'
        ), 2) AS average_time_to_receipt,
        ROUND(AVG(#{prefix}borrowing_turnarounds.total_time) FILTER (
          WHERE #{prefix}transactions.lender_status != 'RES_UNFILLED'
        ), 2) AS average_turnaround
      FROM #{prefix}transactions
      LEFT JOIN #{prefix}borrowing_turnarounds
      ON #{prefix}borrowing_turnarounds.request_id = #{prefix}transactions.borrower_id
      WHERE #{prefix}transactions.borrower = '#{institution}'
      AND #{prefix}transactions.date_created
        BETWEEN '#{fiscal_year - 1}-07-01' AND '#{fiscal_year}-06-30'
      GROUP BY 1
      ORDER BY 1;"
    ).rows

    # Append all rows together and return the result.
    summary_row + institution_rows
  end

  # This function counts the number of fulfillments completed for
  # each month in a fiscal year
  def reshare_monthly_fulfillment(model, institution, fiscal_year, get_borrowing)

    # Get the fiscal year ranges
    this_year, last_year = fiscal_year_ranges(fiscal_year)

    # Build the query to calculate monthly fulfillment
    output_query = model::Reshare::Transaction.select(:request_id).distinct
    .where(lender_status: 'RES_COMPLETE')
    .where(borrower_status: 'REQ_REQUEST_COMPLETE')
    .where(date_created: this_year)

    if get_borrowing
      output_query = output_query.where(borrower: institution)
      .group(:lender)
    else
      output_query = output_query.where(lender: institution)
      .group(:borrower)
    end

    result_map =  output_query.group("CAST(EXTRACT (MONTH FROM date_created) AS int)")
    .count

    # Get a list of display months for the column headings
    months = display_months(this_year).reverse()

    # Get a list of the institution names (row headings)
    institutions = reshare_institution_names(model)

    output_table = []
    # Add in the column headings
    output_table << ["Institutions"] + months.map{|m| Date::MONTHNAMES[m]}

    # Calculate the rollup of all institutions
    rollup = months.map{|m| [m,0]}.to_h
    result_map.each do |k,v|
      rollup[k[1]] = rollup.fetch(k[1] , 0) + v
    end
    output_table << ["All Institutions"] + rollup.values

    # Add in all the institutions
    institutions.each do |i|
      # Skip current institution
      next if i == institution

      row = [i]
      # Add in each month
      months.each do |m|
        row.append(result_map.fetch([i,m], 0))
      end
      # Add the row to the output table
      output_table << row
    end

    return output_table
  end

end

module SpringshareHelper
  # Function to calculate all the available fiscal years
  def springshare_libanswers_fiscal_years
    tickets = Springshare::Libanswers::Ticket

    # Get the max and min fiscal year
    min_fiscal_year = (
      tickets.select(:asked_on).min.asked_on + 6.months
    ).year
    max_fiscal_year = (
      tickets.select(:asked_on).max.asked_on + 6.months
    ).year

    # Return the range of fiscal years
    min_fiscal_year..max_fiscal_year
  end

  # Function to filter Tickets by input parameters
  def springshare_libanswers_filter_tickets(params)
    tickets = Springshare::Libanswers::Ticket

    # Filter tickets based on input of parameters
    tickets = tickets.where(
      queue_id: params[:queue_id]
      ) unless params[:queue_id].blank?
    tickets = tickets.where(
      owner: params[:owner]
      ) unless params[:owner].blank?
    tickets = tickets.where(
      user_group: params[:user_group]
      ) unless params[:user_group].blank?
    tickets = tickets.where(
      school: params[:school]
      ) unless params[:school].blank?
    
    unless params[:fiscal_year].blank?
      this_year, last_year = fiscal_year_ranges(
        params[:fiscal_year].to_i
      )
      tickets.where(asked_on: this_year)
    end

    # Return the filtered tickets
    tickets
  end

  # Function turns a duration value into a set of bins.
  # Bins were chosen by the distribution.
  def springshare_libanswers_group_duration(tickets, column_name)

    # Select all ticket durations
    durations = tickets.order(
      "#{column_name} ASC"
    ).pluck(
      column_name.to_sym
    )

    # Group ticket durations into smaller chunks
    durations.group_by { |v| 
      case
      when v == 0 then '*0 seconds'
      when v < 10.minutes then '10 minutes'
      when v < 30.minutes then '30 minutes'
      when v < 1.hour then '1 hour'
      when v < 2.hours then '2 hours'
      when v < 12.hours then '12 hours'
      when v < 1.day then '1 day'
      when v < 3.days then '3 days'
      else 'Longer'
      end
    }.map { | k, v |
      [k, v.size]
    }
  end
end
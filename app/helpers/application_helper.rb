module ApplicationHelper

  def self.mac_address
    platform = RUBY_PLATFORM.downcase
    output = `#{(platform =~ /win32/) ? 'ipconfig /all' : 'ifconfig'}`
    case platform
      when /darwin/
        $1 if output =~ /en1.*?(([A-F0-9]{2}:){5}[A-F0-9]{2})/im
      when /win32/
        $1 if output =~ /Physical Address.*?(([A-F0-9]{2}-){5}[A-F0-9]{2})/im
      when /linux/
        $1 if output =~ /ether\s+(([A-F0-9]{2}:){5}[A-F0-9]{2})/im
      # Cases for other platforms...
      else nil
    end
  end

  # Function to calculate the fiscal year ranges for
  # both the requested year and the previous year
  def fiscal_year_ranges(fiscal_year)
    start_date = DateTime.new(fiscal_year - 1, 7, 1)
    end_date = [DateTime.now, DateTime.new(fiscal_year, 7, 1)].min
    this_year = start_date..end_date
    last_year = (start_date - 1.year)..(end_date - 1.year)
    return this_year, last_year
  end

  # Function to specify the months to display
  def display_months(fiscal_year)
    current_fiscal_year = (Date.today + 6.months).year

    # Calculate what the last month is
    last_month = (fiscal_year == current_fiscal_year) ? 
      Date.today.month :
      6

    # Return an ordered array of the past months of the fiscal year
    return last_month >= 7 ?
      last_month.downto(7).to_a :
      last_month.downto(1).to_a + 12.downto(7).to_a
  end

  # Function to get the table name prefix for a table
  def table_name_prefix(model)
    return model::Base.table_name_prefix rescue ""
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

  # Method to format the number appropriately
  # This will be used for big integers (> 1000)
  def format_big_number(input)
    output = "---"
    if input and input != 0
      output = ActiveSupport::NumberHelper.number_to_delimited(input)
    end
    return output
  end

  # Format the number of days to 2 decimal places
  def format_into_days(input)
    output = "---"
    if input and input != 0 and not input.to_f.nan?
      output = sprintf('%.2f', input)
    end
    return output
  end

  # Method to check for a key and format the number appropriately
  # This will be used for currencies
  def format_currency(input)
    output = "---"
    if input and input != 0
      output = ActiveSupport::NumberHelper.number_to_currency(input)
    end
    return output
  end

end

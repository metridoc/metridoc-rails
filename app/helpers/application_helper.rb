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
    start_date = Date.new(fiscal_year - 1, 7, 1)
    end_date = [Date.today, Date.new(fiscal_year, 6, 30)].min
    this_year = start_date..end_date
    last_year = (start_date - 1.year)..(end_date - 1.year)
    return this_year, last_year
  end

  # Function to specify the months to display
  def display_months(this_year)
    # Calculate what the last month is
    last_month = this_year.last.month
    # Return an ordered array of the past months of the fiscal year
    return last_month >= 7 ?
      last_month.downto(7).to_a :
      last_month.downto(1).to_a + 12.downto(7).to_a
  end

  # Function to display names of institutions
  def display_institution_names(model, institution_ids)
    render_ids = []
    institution_ids.each do |id, amount|
      render_ids << [
        model.find_by(library_id: id).nil? ?
        "Not Supplied" :
        "#{model.find_by(library_id: id).institution_name} (#{id})",
        amount
      ]
    end
    return render_ids
  end

  # Function to get the table name prefix for a table
  def table_name_prefix(model)
    return model::Base.table_name_prefix rescue ""
  end

end

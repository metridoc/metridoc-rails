# frozen_string_literal: true

module ConsultationHelper
  # Method to access the list of staff pennkeys for use in drop down menu
  def pennkey_list
    Springshare::Libwizard::CandiView.distinct
                             .where
                             .not(staff_pennkey: nil)
                             .pluck(:staff_pennkey)
                             .sort
  end

  # Method to query the default range of dates of the table
  def date_range(pennkey = nil)
    output = Springshare::Libwizard::CandiView
    output = output.where(staff_pennkey: pennkey) unless pennkey.nil?

    [
      output.minimum(:event_date),
      output.maximum(:event_date)
    ]
  end

  # Method to build a date range using either default range of all dates, or selection.
  def minimize_date_range(start_date, end_date, pennkey = nil)
    # Find default range
    default_range = date_range(pennkey)
    # Handle nil start and end date values
    start_date = start_date.nil? ? default_range.first : Date.parse(start_date)
    end_date = end_date.nil? ? default_range.last : Date.parse(end_date)
    # Build the output
    [
      [start_date, default_range.first].max,
      [end_date, default_range.last].min
    ]
  end

  # Method to list all months between two dates
  def find_months_between(dates)

    start_date = dates.first
    end_date = dates.last

    output = []
    # Handle the case where there is no data.
    if start_date.nil? or end_date.nil?
      return output
    end
    # Loop through years
    (start_date.year..end_date.year).each do |y|
      # Find the range of months needed
      start_month = y == start_date.year ? start_date.month : 1
      end_month = y == end_date.year ? end_date.month : 12

      # Loop through months
      (start_month..end_month).each do |m|
        output.append(Date.new(y, m, 1))
      end
    end
    output
  end

  # Method to fill in the missing months with zeroes
  def months_fill_zero(data, months)
    months.map { |m| [m, data[m] ||= 0] }.to_h
  end

  # List of specific event types
  CONSULTATION_KEYS = {
    event_length: 'average',
    prep_time: 'average',
    number_of_interactions: 'sum',
    patron_type: 'group',
    outcome: 'group',
    school_affiliation: 'group',
    research_community: 'group',
    academic_department: 'group',
    mode_of_consultation: 'group',
    service_provided: 'group'
  }.freeze

  INSTRUCTION_KEYS = {
    event_length: 'average',
    prep_time: 'average',
    number_of_registrations: 'median',
    total_attendance: 'median',
    school_affiliation: 'group',
    research_community: 'group',
    academic_department: 'group',
    session_type: 'group',
    location: 'group'
  }.freeze

  KEY_HASH = {
    "Consultation": CONSULTATION_KEYS,
    "Instruction": INSTRUCTION_KEYS
  }.freeze

  # Method to sort counts grouped by an input key
  def key_groups(input_query, key)
    input_query.group(key)
               .count
               .sort_by { |_k, v| v }
               .reverse
  end

  # Method to average a column
  def column_average(input_query, key)
    output = input_query.average(key)
    number_with_precision(output, precision: 1)
  end

  # Method to get the median of a column
  def column_median(input_query, key)
    output = input_query.median(key)
    output || 'Insufficient Data'
  end

  # Method to get the sum of a column
  def column_sum(input_query, key)
    input_query.sum(key)
  end

  # Method to count the number of nils in the column
  def column_nils(input_query, key)
    input_query.count - input_query.count(key)
  end

  # Method to calculate all statistics needed for statistics page
  def event_groups(dates, pennkey = nil)
    output = {}
    dateline = {}

    KEY_HASH.each do |category, category_hash|
      category_output = {}
      events = Springshare::Libwizard::CandiView.where(consultation_or_instruction: category)
      # Safe handling for null pennkey
      events = events.where(staff_pennkey: pennkey) unless pennkey.nil?
      # Filter on date range
      events = events
                 .where('event_date >= ?', dates.first)
                 .where('event_date <= ?', dates.last)

      # Loop through the columns for calculations
      category_hash.each do |column, method|
        # Treat columns differently by method
        category_output[column.to_s] = if method == 'average'
                                         [
                                           column_average(events, column),
                                           column_nils(events, column)
                                         ]
                                       elsif method == 'median'
                                         [
                                           column_median(events, column),
                                           column_nils(events, column)
                                         ]
                                       elsif method == 'sum'
                                         [
                                           column_sum(events, column),
                                           column_nils(events, column)
                                         ]
                                       else
                                         key_groups(events, column)
                                       end
      end # End of category hash loop

      # Group the event date by month.
      # Keep separate for further handling
      dateline[category.to_s] = events.group_by_month(:event_date).count
      dateline[category.to_s].transform_keys!(&:to_date)

      output[category.to_s] = category_output
    end # end of KEY_HASH loop

    # Manipulate timelines to create uniformity
    # Flatten the list of timestamps
    datestamps = dateline.map { |_k, v| v.keys }.flatten
    # Find the full range of months
    months = find_months_between(datestamps.minmax)
    # Fill in zeros for missing months
    dateline.map { |k, v| [k, months_fill_zero(v, months)] }.to_h

    [output, dateline]
  end

  # end of event_groups

  # Function to calculate the mapping between the school_affiliation
  # and the research_community or a particular pennkey and
  # consultation/instruction type
  def chord_data_mapper(kind, pennkey, left, right)
    query = Springshare::Libwizard::CandiView.where(:consultation_or_instruction => kind)

    unless pennkey.nil?
      query = query.where(:staff_pennkey => pennkey)
    end

    # Query the group by mapping between the two variables of interest
    value_map = query.group(left, right).count

    # Transform any nils in the keys
    value_map.transform_keys! { |k|
      [
        k[0].nil? ? "Unknown" : k[0],
        k[1].nil? ? "Unknown" : k[1]
      ]
    }

    output = value_map.map { |k, v| { "A": k[0], "B": k[1], "value": v } }.to_json().html_safe

    return output
  end

  # end of chord mapper
end

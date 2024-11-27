module SpringshareHelper
  # Function to calculate all the available fiscal years
  def springshare_libanswers_fiscal_years
    tickets = Springshare::Libanswers::Ticket

    # Get the max and min fiscal year
    min_fiscal_year = (
      tickets.minimum(:asked_on) + 6.months
    ).year
    max_fiscal_year = (
      tickets.maximum(:asked_on) + 6.months
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
      this_year, _ = fiscal_year_ranges(
        params[:fiscal_year].to_i
      )
      tickets = tickets.where(asked_on: this_year)
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

  def springshare_libchat_category_mapping
    {
      "newspaper": {
        name: "Newspaper Related",
        subcategories: ["Unassigned", "True"]
      },
      "medium": {
        name: "Physical Item Type",
        subcategories: [
          "Unassigned", "Book", "Article", "Music", 
          "Microfilm", "Movie"
        ]
      },
      "services": {
        name: "Library Services",
        subcategories: [
          "Unassigned", "Interlibrary Loan", "Franklin/Find"
        ]
      },
      "type_of_search": {
        name: "Research Assistance",
        subcategories: [
          "Unassigned", "Research", "Coursework", "Librarian", "Thesis", 
          "Database/Software", "Search", "Local"
        ]
      },
      "account_q": {
        name: "Library Account",
        subcategories: [
          "Unassigned", "Account", "Overdue Books", "Physical Borrowing", 
          "Equipment Rental"
        ]
      },
      "top_searches": {
        name: "Frequent Requests",
        subcategories: [
          "Unassigned", "Printing/Posters", "Citations"
        ]
      },
      "subscription_issues": {
        name: "Account Access",
        subcategories: [
          "Unassigned", "Subscription", "Access", "Sign-In"
        ]
      }
    }
    
  end

  # Get a list of school names in an alphabetized array
  def springshare_libchat_school_names

    # List out the primary schools and the Library
    schools = [
      "Annenberg School for Communication",
      "College of Arts & Sciences", 
      "Graduate School of Education",
      "Law School",
      "Perelman School of Medicine",
      "School of Dental Medicine",
      "School of Design",
      "School of Engineering and Applied Science",
      "School of Nursing",
      "Social Policy & Practice",
      "The Wharton School", 
      "Veterinary Medicine",
      "Penn Libraries"
    ].map{|v| [v, v]}.to_h

    # Avoid spamming the database by hardcoding
    other_schools = [
      "Annenberg Center",
      "Annenberg School for Communication",
      "Audit, Compliance and Privacy",
      "Business Resources",
      "Campus Services",
      "College of Arts & Sciences",
      "Comptroller/Division of Finance",
      "DRIA",
      "Development",
      "EVP",
      "FRES",
      "General University",
      "General University Special",
      "Graduate School of Education",
      "Human Resources",
      "ICA",
      "ISC",
      "Law School",
      "Morris Arboretum",
      "Museum",
      "PROV Health & Wellness Administration",
      "Penn Global",
      "Penn Libraries",
      "Penn Praxis",
      "Perelman School of Medicine",
      "President",
      "Provost",
      "Public Safety",
      "School of Dental Medicine",
      "School of Design",
      "School of Engineering and Applied Science",
      "School of Nursing",
      "Social Policy & Practice",
      "The Wharton School",
      "VPUL",
      "Veterinary Medicine"
    ] - schools.keys

    other_schools.each do |school|
      schools[school] = "Other"
    end

    # Map the missing schools to Unknown
    schools["Unknown"] = "Unknown"
    schools[nil] = "Unknown"
    schools[""] = "Unknown"

    # Return the final mapping of demographic school 
    # name to bundled school name
    schools
  end

  # Get a list of User Types in an alphabetized array
  def springshare_libchat_user_groups
    user_groups = {
      "Alumni": "Alumni",
      "Associate": "Faculty",
      "Borrow Direct Plus": "Faculty",
      "Courtesy Borrower": "Other",
      "Drexel Faculty": "Other",
      "Faculty": "Faculty",
      "Faculty Express": "Faculty",
      "Faculty Spouse": "Other",
      "GIC textbook users": "Undergraduate Student",
      "Grad Student": "Graduate Student",
      "Library Staff": "Library Staff",
      "Medical Center Staff": "Staff",
      "Reciprocal Borrower": "Other",
      "Retired Library Staff": "Library Staff",
      "Staff": "Staff",
      "Undergraduate Student": "Undergraduate Student",
      "purge": "Unknown",
      "Unknown": "Unknown",
      "": "Unknown"
    }

    user_groups
  end

  # Get an ordered list of the sentiment names
  def springshare_libchat_sentiment_names
    {
      "Ecstatic": "#011F5B", 
      "Positive": "#82AFC3", 
      "Neutral": "#F2C100", 
      "Negative": "#990000"
    }
  end

  # Get an ordered list of the sentiment names
  def springshare_libchat_referrers
    {
      "faq.library.upenn.edu": "FAQ", 
      "find.library.upenn.edu": "Find", 
      "franklin.library.upenn.edu": "Franklin", 
      "guides-library-upenn-edu.proxy.library.upenn.edu": "LibGuides",
      "guides.library.upenn.edu": "LibGuides",
      "upenn.summon.serialssolutions.com": "Summon",
      "www-library-upenn-edu.proxy.library.upenn.edu": "Library Website",
      "www.library.upenn.edu": "Library Website"
    }
  end

  def springshare_libchat_filtered_chats(params)
    chats = Springshare::Libchat::Chat.eager_load(:inquiry_map)

    # Filter chats by fiscal year
    chats = chats.where(
      fiscal_year: params[:fiscal_year]
      ) unless params[:fiscal_year].blank?

    # Filter chats by librarian
    chats = chats.where(
      answerer: params[:answerer]
      ) unless params[:answerer].blank?

    # Filter chats by category
    chats = chats.where.not(
      inquiry_map: {params[:category] => 0}
      ) unless params[:category].blank?

    # Eager load the InquiryMap objects
    # One SQL call for whole page
    chats.all
  end

  # Function to perform rollups of columns by fiscal year
  def springshare_libchat_rollup_fiscal_year(chats, column_name)
    groups = chats.group(column_name.to_sym, :fiscal_year).count

    totals = {}
    # Loop through all the grouped items
    groups.each do |k, v|
      # Set the key based on the column name
      if column_name == "school"
        key = [
          springshare_libchat_school_names.fetch(k.first, "Unknown"), 
          k.last
        ]
      elsif column_name == "user_group"
        key = [
          springshare_libchat_user_groups.fetch(k.first.to_sym, "Unknown"), 
          k.last
        ]
      elsif column_name == "referrer_basename"
        key = [
          if k.first.nil? 
            then "Unknown" 
          else springshare_libchat_referrers.fetch(k.first.to_sym, "Unknown") 
          end,
          k.last
        ]
      else
        key = k.map{|e| e.nil? ? "Unknown" : e}
      end
      totals[key] = totals.fetch(key, 0) + v
    end

    # Sort based on column name
    if  column_name == "school"
      ending_order = ["Penn Libraries", "Other", "Unknown"]
      totals = totals.sort_by do |k,_|
        [
          [ending_order.include?(k.first) ? 1 : 0, k.first],
          k.last
        ]
      end.to_h
    elsif column_name == "user_group"
      ending_order = ["Library Staff", "Other", "Unknown"]
      totals = totals.sort_by do |k,_|
        [
          [ending_order.include?(k.first) ? 1 : 0, k.first],
          k.last
        ]        
      end.to_h
    else 
      # Alphabetically sort
      totals = totals.sort_by(&:first).to_h
    end

    return totals
    
  end

  # Function to perform rollups of columns
  def springshare_libchat_rollup(chats, column_name)

    # The number of chats
    n_chats = chats.length

    # Pluck the column from the input
    totals = chats.map(&column_name.to_sym)

    # Use mappings if needed based on column name
    if column_name == "school"
      totals = totals.map{
        |c| springshare_libchat_school_names.fetch(c, "Unknown")
      }
    elsif column_name == "user_group"
      totals = totals.map{
        |c| springshare_libchat_user_groups.fetch(c.to_sym, "Unknown")
      }
    end

    # Tally up the column values
    totals = totals.tally.sort_by{|k,_| k}.to_h

    # Calculate the percentage of school affiliations
    percentages = totals
    .transform_values { |v| v.fdiv(n_chats) * 100}

    return totals, percentages
  end

  # Function turns a duration value into a set of bins.
  # Bins were chosen by the distribution.
  def springshare_libchat_group_duration(chats)

    # Select all chat durations
    durations = chats.order(:duration).pluck(:duration)

    # Group chat durations into smaller chunks
    durations.group_by { |v| 
      case
      when v < 60*15 then "#{v/60.ceil} to #{v/60.ceil + 1}"
      else '> 15'
      end
    }.map { | k, v |
      [k, v.size]
    }
  end

  # Function turns the number of messages into a set of bins.
  # Bins were chosen by the distribution.
  def springshare_libchat_group_messages(chats)

    # Select all chat message counts
    messages = chats.order(:message_count).pluck(:message_count)

    # Group chat message counts into smaller chunks
    messages.group_by { |v| 
      case
      when v < 30 then "#{v/5.ceil * 5} to #{v/5.ceil * 5 + 5}"
      else '>30'
      end
    }.map { | k, v |
      [k, v.size]
    }
  end

  # Function turns the wait time into a set of bins.
  # Bins were chosen by the distribution.
  def springshare_libchat_group_wait_time(chats)

    # Select all chat message counts
    wait_time = chats.order(:wait_time).pluck(:wait_time)

    # Group chat message counts into smaller chunks
    wait_time.group_by { |v| 
      case
      when v < 5 then "0 to 5"
      when v < 10 then "5 to 10"
      when v < 15 then "10 to 15"
      when v < 30 then "15 to 30"
      when v < 60 then "30 to 60"
      else '> 60'
      end
    }.map { | k, v |
      [k, v.size]
    }
  end

  def springshare_libcal_chats_by_fiscal_year(chats)
    # Group all chats by fiscal year
    all_chats = chats.group(:fiscal_year).count
    # Group all chats with tickets by fiscal year
    chats_with_tickets = chats
    .where.not(ticket_id: 0)
    .group(:fiscal_year)
    .count

    # Build a table mapping the fiscal year to table entries
    # Ordered by the fiscal year
    all_chats.map { |k,v| 
      [
        k, 
        format_big_number(v), 
        format_big_number(chats_with_tickets.fetch(k,0)), 
        format_percent(chats_with_tickets.fetch(k,0).fdiv(v))
      ]
    }.sort_by{|v| v.first}

  end

  # Function takes in chats and groups them by sentiment
  # And other specified grouper
  # Returns the data for plotting and the colors to use
  def springshare_inquirymap_sentiment(chats, grouping)
    # Group the chats by sentiment
    chats = chats.group(:sentiment)
    
    # Group by specified grouper
    if grouping == "fiscal_year"
      chats = chats.group(:fiscal_year)
    elsif grouping == "week"
      chats = chats.group_by_week(:timestamp)
    elsif grouping == "month"
      chats = chats.group_by_month(:timestamp, format: "%b %Y")
    end
    
    # Count up the chats by sentiment
    # Sort the chats by descending sentiment order
    chats = chats.count.sort_by{
      |k,_| springshare_libchat_sentiment_names.keys.index(k[0].to_sym)
    }.to_h

    # Make a list of colors to use for plotting
    colors = chats.map{
      |k,_| springshare_libchat_sentiment_names.fetch(k[0].to_sym)
    }.uniq

    return chats, colors
  end

  # Gruop the chats successfully labelled by category and time
  def springshare_inquirymap_categories(chats, grouping)
    # Loop through each category to get the grouped data
    springshare_libchat_category_mapping.keys
    .map do |category|
      # Filter out chats where the category is not assigned
      output = chats.where.not(
        inquiry_map: {category.to_sym => 0}
      )

      # Group by specified grouper
      if grouping == "fiscal_year"
        output = output.group(:fiscal_year)
      elsif grouping == "week"
        output = output.group_by_week(:timestamp)
      elsif grouping == "month"
        output = output.group_by_month(:timestamp, format: "%b %Y")
      end

      # Count instances and transform the keys
      output = output.count
      .transform_keys{
        |v| [
          springshare_libchat_category_mapping[category][:name],
          v
        ]
      }

      output
    end.inject(:merge)
  end

  # Group the chats successfully labeled by a category
  # by a time frame and the subcategory
  def springshare_inquirymap_subcategories(chats, grouping, category)

    if category.blank?
      return springshare_inquirymap_categories(chats, grouping)
    end
    # Filter out unassigned subcategories
    output = chats.where.not(
      inquiry_map: {category.to_sym => 0}
    ).group(category.to_sym)

    # Group by specified grouper
    if grouping == "fiscal_year"
      output = output.group(:fiscal_year)
    elsif grouping == "week"
      output = output.group_by_week(:timestamp)
    elsif grouping == "month"
      output = output.group_by_month(:timestamp, format: "%b %Y")
    end
    
    # Perform the count and transform the output keys
    output = output.count
    .transform_keys{
      |a, b| 
      [
        springshare_libchat_category_mapping[category.to_sym][:subcategories][a.to_i],
        b
      ]
    }.sort_by {|k,_| k[0]}.to_h

    output
  end 

  def springshare_inquirymap_filtered_chats(params)
    chats = Springshare::Libchat::Chat.joins(:inquiry_map)

    # Filter chats by fiscal year
    chats = chats.where(
      fiscal_year: params[:fiscal_year]
      ) unless params[:fiscal_year].blank?

    # Pull in the category names
    categories = springshare_libchat_category_mapping.keys

    # Group by the sentiment and Affilation
    chats = chats.group(:sentiment, :school, :user_group)
    # Group by the InquiryMap categories
    chats = chats.group(categories)
    # Count occurences
    chats = chats.count

    # Fill in a output hash with the appropriate key names
    # This uses the mappings to condense the keys to preferred groupings
    temp_chats = {}
    chats.each do |k,v|
      # Build the category key
      category_key = categories.map.with_index(3) do |category, index|
        springshare_libchat_category_mapping[category][:subcategories][k[index]]
      end

      # Construct a new key
      new_key = [
        k[0], # Sentiment-no change needed
        springshare_libchat_school_names.fetch(k[1], "Unknown"), # School Mapping
        springshare_libchat_user_groups.fetch(k[2].to_sym, "Unknown"), # User Groups
      ] + category_key

      # Add the new key to the output
      temp_chats[new_key] = temp_chats.fetch(new_key, 0) + v
    end

    # Turn the Hash into an array of hashes, one for each key
    output = temp_chats.map do |k, v|
      new_hash = {
        sentiment: k[0],
        school: k[1],
        user_group: k[2],
        value: v
      }
      categories.map.with_index(3) do |category, index|
        new_hash[category] = k[index]
      end

      new_hash
    end

    output
  end


  # Function to perform rollups of columns
  def springshare_inquirymap_rollup(chats, column_name, category)
    totals = {}

    # If no category is specified, look at the major categories only
    if category.blank?
      # Loop through each major category
      springshare_libchat_category_mapping.keys.each do |c|
        # Set the totals to the sum of the values
        chats.each do |chat|
          # Skip the categories that are not flagged
          next if chat[c.to_sym] != "Unassigned"
          # Construct a two part key for the column name and the category
          key = [
            chat[column_name.to_sym], 
            springshare_libchat_category_mapping[c][:name]
          ]
          # Add the value to the totals by the key
          totals[key] = totals.fetch(key, 0) + chat[:value]
        end

      end
    else
      # Otherwise bundle by subcategory
      # Loop through the entries in the array
      chats.each do |chat|
        # Skip this chat if it was not assigned to the subcategory
        next if chat[category.to_sym] == "Unassigned"
        # Construct a two part key for the column name and the subcategory
        k = [chat[column_name.to_sym], chat[category.to_sym]]

        # Add the key to the output and add the value
        totals[k] = totals.fetch(k,0) + chat[:value]
      end
    end

    if column_name == "sentiment"
      # Sort by sentiment, then subcategory name
      totals = totals.sort_by do |k,_|
        [
          springshare_libchat_sentiment_names.keys.index(k.first.to_sym),
          k.last
        ]
      end.to_h

      colors = totals.map do |k,_|
        springshare_libchat_sentiment_names.fetch(k.first.to_sym)
      end.uniq

      return totals, colors
    elsif column_name == "school"
      ending_order = ["Penn Libraries", "Other", "Unknown"]
      totals = totals.sort_by do |k,_|
        [
          [ending_order.include?(k.first) ? 1 : 0, k.first],
          k.last
        ]
      end.to_h
    elsif column_name == "user_group"
      ending_order = ["Library Staff", "Other", "Unknown"]
      totals = totals.sort_by do |k,_|
        [
          [ending_order.include?(k.first) ? 1 : 0, k.first],
          k.last
        ]
      end.to_h
    end

    return totals
  end

  # Build a crosstab table of the subcategories to other categories
  def springshare_inquirymap_subcategories_crosstab(chats, category)
    
    # When category is blank
    if category.blank?
      # Set up the first row
      output = [
        [""] + springshare_libchat_category_mapping.map{
          |k, v| v[:name]
        }.reverse
      ]

      springshare_libchat_category_mapping.keys.each_with_index do |c1, index1|
        row = [springshare_libchat_category_mapping[c1][:name]]

        index_limit = springshare_libchat_category_mapping.length - 1 - index1
        springshare_libchat_category_mapping.keys.reverse.each_with_index do |c2, index2|
          # Only want the upper triangle, set the rest of the table to blank
          if index_limit < index2
            row.append("")
            next
          end

          # Sum the values where the chats are assigned to both c1 and c2 categories
          value = chats.select{
            |chat| chat[c1] != "Unassigned"
          }.select{
            |chat| chat[c2] != "Unassigned"
          }.map{
            |chat| chat[:value]
          }.sum

          row.append(format_big_number(value))
        end
        output.append(row)
      end
      return output
    end

    # Get a list of all the subcategories of the main category
    subcategories = springshare_libchat_category_mapping[
      category.to_sym
    ][:subcategories].select{|k| k != "Unassigned"}
    # Get a list of all the categories besides the main category
    other_categories = springshare_libchat_category_mapping.keys.select{
      |k| k != category
    }

    # Build the first row of table
    # Map the other categories to their human readable names
    output = [
      [""] + other_categories.map {
        |k| springshare_libchat_category_mapping[k][:name]
      } 
    ]

    # Loop through all possible subcategories
    subcategories.sort.each do |subcategory|
      row = [subcategory]
      # Loop through the other categories
      other_categories.each do |other_category|
        # Select the chats that have both the subcategory and category
       value = chats.select{
          |chat| chat[category.to_sym] == subcategory
        }.select { 
          |chat| chat[other_category.to_sym] != "Unassigned"
        }.map{
          # Map/Reduce the remaining chats
          |chat| chat[:value]
        }.sum

        # Add the value to the table row
        row = row.append(format_big_number(value))
      end
      # Add the table row to the table
      output.append(row)
    end
    output
  end

end
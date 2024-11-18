module SpringshareHelper
  
  #define arrays and hashes that are consistently used.
  def springshare_lc_category_names
    ["medium", "type_of_search", "services", "account_q", "top_searches", "subscription_issues", "newspaper"]
  end
  
  def springshare_lc_demographics_names
    ["Student", "Faculty", "Visitor", "Alumni"]
  end

  def springshare_lc_sentiment_names
    ["Ecstatic", "Positive", "Neutral", "Negative"]
  end  

  def lc_school_names
      ["College of Arts & Sciences","The Wharton School","Annenberg School for Communication",
"School of Dental Medicine","School of Design","Graduate School of Education",
"School of Engineering and Applied Science","Law School","Perelman School of Medicine",
"Veterinary Medicine","School of Nursing","School of Social Policy & Practice"]
  end    
    
  def springshare_lc_subcat_names
    subcats=Hash.new
    subcats['newspaper']=["True"]
    subcats['medium']=['Book', "Article", "Music", "Microfilm", "Movie"]
    subcats['services']=['Interlibrary Loan', "Franklin/Find"]
    subcats['type_of_search']=['Research', 'Class', 'Librarian', 'Thesis', 'Database/Software', 'Search', 'Local']
    subcats['account_q']=['Account','Overdue Books','Physical Borrow','Equipment Rental']
    subcats['top_searches']=['Printing/Posters','Citations']
    subcats['subscription_issues']=['Subscription','Access','Sign-in']
    return subcats
  end

  def springshare_lc_sublabels(data, main_cat)

    my_labels=Array.new
    
    for d in data
        my_labels.push(springshare_lc_subcat_names[main_cat][data[d-1]])
    end
    
    return my_labels 
  end

  def springshare_lc_transform_keys(input_hash,input_q)

    input_hash.transform_keys! {|k| springshare_lc_subcat_names[input_q][k-1]}
    return input_hash
    
  end  

  def springshare_lc_fiscal_counts(input_table)

    yearly_chats=input_table.order(:timestamp).select(:timestamp).map{|u| (u.timestamp + 6.months).year}.tally
    return yearly_chats
      
  end  
  
  #Construct hashes for the number of chats in each category. The type determiens whether all categories are used, or if tandem counts between two categories should be used.
  def springshare_lc_q_cats(type, input_table)

      cats_by_med=["type_of_search", "services", "account_q", "top_searches", "subscription_issues", "newspaper"]
      cats_by_type=["medium", "services", "account_q", "top_searches", "subscription_issues", "newspaper"]
      cats_by_type=["medium", "services", "account_q", "top_searches", "type_of_search", "newspaper"]
      
      count_array=Hash.new
    
      if type=="counts"
         for c in springshare_lc_category_names     
             count_array["#{c}"]=input_table.where(c + "> 0").count
         end
      elsif type=="medium"
         for c in cats_by_med   
             count_array["#{c}"]=input_table.where('medium > 0').where(c + "> 0").count
         end
      elsif type=="type"         
         for c in cats_by_type   
             count_array["#{c}"]=input_table.where('type_of_search > 0').where(c + "> 0").count
         end
      elsif type=="subscription"         
         for c in cats_by_type   
             count_array["#{c}"]=input_table.where('subscription_issues > 0').where(c + "> 0").count
         end  
      end
      return count_array
  end

  #Change numbers of chats to percents:
  def springshare_lc_percents(input_hash)

    total=input_hash.values.sum  
    input_hash.transform_values! {|v| v.fdiv(total)*100}
    return input_hash
    
  end

  #Make a cooccurrence plot for all of the chats in different categories:
  def springshare_lc_cooccurrence(input_table)
      
      count_array=Hash.new
      
      for c in springshare_lc_category_names
        for second_c in springshare_lc_category_names    
          count_array["#{c}_#{second_c}"]=input_table.where(c + "> 0").where(second_c + "> 0").count
        end  
      end
      return count_array
  end

  #Get the number of chats with a given sentiment for a particular category of question:
  def springshare_lc_sentiment_bars(input_table)
    positive_data=Hash.new
    ecstatic_data=Hash.new
    negative_data=Hash.new
    neutral_data=Hash.new
    for c in springshare_lc_category_names
        positive_data["#{c}"]=input_table.where(sentiment: "Positive").where(c.to_s + "> 0").count
        ecstatic_data["#{c}"]=input_table.where(sentiment: "Ecstatic").where(c.to_s + "> 0").count
        negative_data["#{c}"]=input_table.where(sentiment: "Negative").where(c.to_s + "> 0").count
        neutral_data["#{c}"]=input_table.where(sentiment: "Neutral").where(c.to_s + "> 0").count
    end
    return positive_data, ecstatic_data, negative_data, neutral_data
  end  

  #Assign consistent color labels to affiliation plots and sentiment plots:
  def springshare_lc_colors(data, labels)

    score_colors= {labels[0] => "blue", labels[1] => "green", labels[2] => "orange", labels[3] => "red"}
    my_colors= []
    data.each do |name, _|
      my_colors << score_colors[name]
    end
    
    return my_colors  
  end
  
  #Get bins for number of messages/length of chat histograms.
  def springshare_lc_hist_bins(input_table,type)

    if type=="messages"
       binsize=5
       bin_ranges=(5..65).step(binsize).to_a
    elsif type=="seconds"
       binsize=250
       bin_ranges=(250..3500).step(binsize).to_a
    end

    hist_counts=Hash.new

    for bin in bin_ranges
        bin_start=bin-binsize
        if type=="messages"
           hist_counts["#{bin_start}-#{bin}"]=input_table.where("message_count < #{bin}").where("message_count > #{bin}-#{binsize}").count
        elsif type=="seconds"
           hist_counts["#{bin_start}-#{bin}"]=input_table.where("duration < #{bin}").where("duration > #{bin}-#{binsize}").count
        end  
    end
    return hist_counts
  end  
  
  #Put the demographic data in bins. Options for count_type are "time" and "categories". This function is used for the tables generated in "_statistics.html.haml" and "demographics.html.haml"
  
  def springshare_lc_counts(input_table,count_type)

      visitor_array=Hash.new
      student_array=Hash.new
      alumni_array=Hash.new
      faculty_array=Hash.new

      year_range=(input_table.pluck(:fiscal_year).min..input_table.pluck(:fiscal_year).max).to_a
      
      if count_type=="time"
         for d in springshare_lc_demographics_names
           copy_table=input_table.where(user_type: d)
           
           for y in year_range
             fiscal_year_count=copy_table.where(fiscal_year: y).count

             if d=="Visitor"
                visitor_array["#{y}"]=fiscal_year_count
             elsif d=="Alumni"
                alumni_array["#{y}"]=fiscal_year_count
             elsif d=="Faculty"
                faculty_array["#{y}"]=fiscal_year_count
             elsif d=="Student"
                student_array["#{y}"]=fiscal_year_count
             end  
           end  
         end    
      end

      if count_type=="categories"
         for d in springshare_lc_demographics_names
           copy_table=input_table.where(user_type: d)

           for c in springshare_lc_category_names
             category_count=copy_table.where(c + " > 0").count

             if d=="Visitor"
                visitor_array["#{c}"]=category_count
             elsif d=="Alumni"
                alumni_array["#{c}"]=category_count
             elsif d=="Faculty"
                faculty_array["#{c}"]=category_count
             elsif d=="Student"
                student_array["#{c}"]=category_count
             end  
           end  
         end  
      end
      return visitor_array,alumni_array,faculty_array,student_array  
  end 
  
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
end

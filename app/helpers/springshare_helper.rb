module SpringshareHelper

    #define arrays and hashes that are consistently used.
    def category_names
    ["Medium", "Type of Search", "Services", "Account_Q", "Top Searches", "Subscription_Issues", "Newspaper"]
  end
  
  def demographics_names
    ["Student", "Faculty", "Visitor", "Alumni"]
  end  
    
    #These first four functions are for the libchats: 
    def lc_q_cats
      
      output_table=Springshare::Libchats::Flags.connection.select_all(
         "SELECT
           sentiment
           sentiment_score
           timestamp
           message_count
           DATE_PART('year', swipe_date + INTERVAL '6 month') AS fiscal_year
           CASE
                WHEN visitor_q=='TRUE'
                  THEN 'Visitor'
                WHEN alumni_q=='TRUE'
                  THEN 'Alumni'
                WHEN student_q=='TRUE'
                  THEN 'Student'
                WHEN faculty_q=='TRUE'
                  THEN 'Faculty'
           END AS user_type
           CASE
                WHEN newspaper=='TRUE'
                  THEN 'Newspaper'
                WHEN 'Medium' > 0
                  THEN 'Medium'
                WHEN top_searches > 0
                  THEN 'top_searches'
                WHEN services > 0
                  THEN 'services'
                WHEN account_q > 0
                  THEN 'account'
                WHEN subscription_issues > 0
                  THEN 'subscription'
                WHEN type_of_search > 0
                  THEN 'type_of_search'
           END AS q_type
           
         FROM libchats;")

      return output_table.to_a
  end

  def filter_chats_dem(params)

      # Filter tickets based on input of parameters
      chats_by_q = lc_q_cats.where(
      user_type: params[:user_type]
      ) unless params[:user_type].blank?
    
      unless params[:fiscal_year].blank?
        this_year, _ = lc_q_cats.maximum(:fiscal_year)

        chats_by_q = chats_by_q.where(fiscal_year: this_year)
      end

      #Return this value
      chats_by_q
    
  end

  def filter_chats_q(params)

      # Filter tickets based on input of parameters
      chats_by_q = lc_q_cats.where(
      user_type: params[:user_type]
      ) unless params[:user_type].blank?

      chats_by_q = chats_by_q.where(
      q_type: params[:q_type]
      ) unless params[:q_type].blank?
      
      unless params[:fiscal_year].blank?
        this_year, _ = lc_q_cats.maximum(:fiscal_year)

        chats_by_q = chats_by_q.where(fiscal_year: this_year)
      end

      #Return this value
      chats_by_q
    
  end
  
  #Put the demographic data in bins. Options for count_type are "time" and "categories".
  #This function is used for the tables generated in "_libchat_statistics.html.haml" and "demographics.html.haml"
  
  def lc_counts(input_table,count_type)

      visitor_array=Hash.new
      student_array=Hash.new
      alumni_array=Hash.new
      faculty_array=Hash.new
      
      year_range=(lc_demographics.minimum("fiscal_year")..lc_demographics.maximum("fiscal_years")).to_a

      if count_type=="time"
      #first select, then pluck, then count?
         for d in demographics_names
           copy_table=input_table.select{|h| h["user_type"]==d}

           for y in year_range
             fiscal_year_count=copy_table.select{|h| h["fiscal_year"]==y}.count

             if d=="visitor"
                visitor_array["{y}"]=fiscal_year_count
             elsif d=="alumni"
                alumni_array["{y}"]=fiscal_year_count
             elsif d=="faculty"
                faculty_array["{y}"]=fiscal_year_count
             elsif d=="student"
                student_array["{y}"]=fiscal_year_count
             end  
           end  
         end
         return visitor_array,alumni_array,faculty_array,student_array    
      end

      if count_type=="categories"
      #first select, then pluck, then count?
         for d in demographics_names
           copy_table=input_table.select{|h| h["user_type"]==d}

           for c in category_names
             category_count=copy_table.select{|h| h["q_type"]==c}.count

             if d=="visitor"
                visitor_array["{c}"]=category_count
             elsif d=="alumni"
                alumni_array["{c}"]=category_count
             elsif d=="faculty"
                faculty_array["{c}"]=category_count
             elsif d=="student"
                student_array["{c}"]=category_count
             end  
           end  
         end
         return visitor_array,alumni_array,faculty_array,student_array    
      end
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

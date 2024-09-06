module LibchatHelpher
  #define arrays and hashes that are consistently used

  #Will need to have a table that keeps track of number of chats per category: like gc_percents, or a group_by statement?
  
  def category_names
    ["Medium", "Type of Search", "Services", "Account_Q", "Top Searches", "Subscription_Issues", "Newspaper"]
  end
  
  def demographics_names
    ["Student", "Faculty", "Visitor", "Alumni"]
  end  
    
    #define tables that are frequently used: will be selecting for percentages AND for time:

  #Don't need lc_demographics anymore?

=BEGIN
  
   #Might be ok for the pie chart?
   def lc_demographics
      
      output_table=Libchat::LibChats.connection.select_all(
        "SELECT
           COUNT(visitor_q)/COUNT(chat_id) AS percent_visitors
           COUNT(alumni_q)/COUNT(chat_id) AS percent_alumni
           COUNT(student_q)/COUNT(chat_id) AS percent_students
           COUNT(faculty_q)/COUNT(chat_id) AS percent_staff
         FROM libchats;")

      return output_table.to_a
   end

=END
   
#The problem here and for the demographics is that there can be multiple entries in a single row...
=BEGIN
  def lc_q_cats
      
      output_table=Libchat::LibChats.connection.select_all(
        "SELECT
           COUNT(newspaper)/COUNT(chat_id) AS percent_news
           COUNT(medium)/COUNT(chat_id) AS percent_medium
           COUNT(top_searches)/COUNT(chat_id) AS percent_freq_searches
           COUNT(services)/COUNT(chat_id) AS percent_services
           COUNT(account_q)/COUNT(chat_id) AS percent_account
           COUNT(subscription_issues)/COUNT(chat_id) AS percent_subscription
           COUNT(type_of_search)/COUNT(chat_id) AS percent_type_searches
         FROM libchats;")

      return output_table.to_a
  end

=END

    def lc_q_cats
      
      output_table=Libchat::LibChats.connection.select_all(
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

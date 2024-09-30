module SpringshareHelper

    #Now update the accompanying flags:
    #for index in (0..ss_libchats_flags.chat_id.length).to_a
    #    if ss_libchats_flags.user_group=="Undergraduate Student" or ss_libchats_flags.user_group=="Grad Student"
    #       student_q=1
    #    elsif ss_libchats_flags.user_group=="Alumni" #double check that this is correct...
    #       alumni_q=1
    #    elsif ss_libchats_flags.user_group=="Staff" or ss_libchats_flags.user_group=="Faculty"
    #       faculty_staff_q=1
    #    end  
    #end  
    #end
  
  def self.update_sentiment
    
    transcript=ss_libchats_flags.select(:transcript)
    id=ss_libchats_flags.select(:chat_id)
    
    #Need to double check that it's not a librarian:
    librarians=["Mercy Ayilo", "David Azzolina", "Mary Kate Baker", "Marcella Barnhart", "Alexandra Bartley", "Elizabeth Blake", "Megan Brown", "Michael Carroll", "Melanie Cedrone", "Charles Cobine", "Claire Cornelius","Sarabeth Coyle", "Cynthia Cronin-Kardon", "Mia D'Avanza", "Mety Damte", "Alisha Davis", "Phebe Dickson", "Rory Duffy", "Bethany Falcon", "Gwen Fancy", "Anna-Alexandra Fodde-Reguer", "Brie Gettleson", "Alexandrea Glenn", "Larissa Gordon", "Stephen Hall", "Joe Holub", "Heather Hughes", "Lonya Humphrey", "Madison Jurgens", "Aman Kaur","Sam Kirk", "Connie Kolakowski", "Varvara (Barbara) Kountouzi", "Lippincott Library", "Margy Lindem", "Nicole Mackowiak", "Allison Madar", "Doug McGee", "Rebecca Mendelson", "Nick Okrent", "Kirsten Painter", "Natalie Pendergast", "Mayelin Perez", "Bob Persing", "Jef Pierce", "Dot Porter", "Katie Rawson", "Oliver Seifert-Gram", "Alexandra Servey", "Matthew Sharp", "Erin Sharwell", "Rebecca Stuhr", "Victoria Sun", "Kevin Thomas", "Joanna Thompson", "Matthew Trowbridge", "Liza Vick", "Brian Vivier", "Mia Wells", "Holly Zerbe"]
  
    last_q_entry=Array.new
    trunc_IDS=Array.new
    sentiment_flag=Array.new
    
    #Tokenize into words so can identify where ":" is:
    for entry in transcript
      id_sel=transcript.index(entry) 
      stop=0
      entry.to_s
      sep_entry=trunc_entry.split("\n")

      transcript=Array.new
      
      for line in sep_entry

        switch=0
        
        for name in librarians
          if name in sep_entry
             switch=1
          end

          if switch=1 then next
          elsif switch=0
             transcript.push(sep_entry.split(':')[3..])
          end  
        end
      end

      all_compounds=Array.new
      
      for user_line in transcript
  
          #Produces a hash: but need to average the compound values:
          user_sentiment=VaderSentimentRuby.polarity_scores(user_line)
        
          all_compounds.push(user_sentiment["compound"])
            
      end

      avg_compound=all_compouds.sum/all_compounds.length
      
      entry_to_edit=ss_libchats_flags.find(chatid: id[id_sel])
      entry_to_edit.sentiment_score.edit = avg_compound
      if avg_compound <= -0.05
         entry_to_edit.sentiment="Negative"
      elsif avg_compound > -0.05 and avg_compound < 0.05
         entry_to_edit.sentiment="Neutral"
      elsif avg_compound >= 0.05 and avg_compound < 0.3
         entry_to_edit.sentiment="Positive"
      elsif avg_compound >= 0.3
         entry_to_edit.sentiment="Ecstatic"
      entry_to_edit.save
      end      
    end  
  end
  
  #define arrays and hashes that are consistently used.
  def category_names
    ["Medium", "Type_of_Search", "Services", "Account_Q", "Top_Searches", "Subscription_Issues", "Newspaper"]
  end
  
  def demographics_names
    ["Student", "Faculty", "Visitor", "Alumni"]
  end

  def sentiment_names
    ["Negative", "Neutral", "Positive", "Ecstatic"]
  end  
    
    #These first four functions are for the libchats: 
  def lc_q_cats
      
      output_table=Springshare::Libchats::Flags.connection.select_all(
         "SELECT
           sentiment,
           sentiment_score,
           timestamp,
           message_count,
           DATE_PART('year', timestamp + INTERVAL '6 month') AS fiscal_year,
           CASE
                WHEN visitor_q=='TRUE'
                  THEN 'Visitor'
                WHEN alumni_q=='TRUE'
                  THEN 'Alumni'
                WHEN student_q=='TRUE'
                  THEN 'Student'
                WHEN faculty_q=='TRUE'
                  THEN 'Faculty'
           END AS user_type,
           CASE
                WHEN newspaper=='TRUE'
                  THEN 'Newspaper'
                WHEN 'Medium' > 0
                  THEN 'Medium'
                WHEN top_searches > 0
                  THEN 'Top_Searches'
                WHEN services > 0
                  THEN 'Services'
                WHEN account_q > 0
                  THEN 'Account'
                WHEN subscription_issues > 0
                  THEN 'Subscription'
                WHEN type_of_search > 0
                  THEN 'Type_of_Search'
           END AS q_type
           
         FROM ss_libchats_flags;")

      return output_table.to_a
  end

  def top_referrers
      
    output_table=Springshare::Libchats::Flags.connection.select_all(
         "SELECT
           timestamp,
           DATE_PART('year', timestamp + INTERVAL '6 month') AS fiscal_year,
           CASE
                WHEN referrer ILIKE 'https://www.library.upenn.edu'
                  THEN 'Homepage'
                WHEN referrer LIKE '%Franklin%'
                  THEN 'Franklin'
                WHEN referrer LIKE '%guide%' or referrer LIKE '%faq%'
                  THEN 'Guide'
                WHEN referrer LIKE '%proxy%'
                  THEN 'proxy'
           END AS referrer_type
           
         FROM ss_libchats_flags;")

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

  def sentiment_bars
    sentiment_counts=Hash.new
    for s in sentiment_names
        sentiment_counts["{s}"]=lc_q_cats.where(sentiment: s).group(:q_type).count
    end
    return sentiment_counts
  end  

  def colormap_vals
    size_array=Hash.new
    color_array=Hash.new
    color_array["Newspaper"]=libchats.where(newspapers: true).count
    size_array["Newspaper"]=libchats.where(newspapers: true).average(:sentiment_score)
    for c in category names
      copy_table=lc_q_cats.select{|h| h["q_type"]==c}
      unique_vals=copy_table.pluck(c.to_sym).uniq
      color_array["{c}"]=copy_table.where(c.to_sym > 0).count
      size_array["{c}"]=copy_table.where(c.to_sym > 0).average(:sentiment_score)
      for u in unique_vals
        hash_label=c+"_"+u.to_s
        color_array["{hash_label}"]=copy_table.where(c.to_sym u).count
        size_array["{hash_label}"]=copy_table.where(c.to_sym u).average(:sentiment_score) 
      end
    end  
    return size_array,color_array
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

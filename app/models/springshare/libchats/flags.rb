class Springshare::Libchats::Flags < Springshare::Libchats::Base

require 'vader_sentiment_ruby'
  
#Put columns to privatize here:

  def self.superadmin_columns
    ["name", "contact_info", "ip","user_agent", "answerer", "timestamp", "user_field_1", "user_field_2", "user_field_3", "initial_question","internal_note", "transcript", "penn_id","pennkey"]
  end

  def self.alternate_id
    "chat_id"
  end
  
  def self.update_flags
    query= <<-SQL

      UPDATE ss_libchats_flags
      SET fiscal_year=DATE_PART('year', timestamp + INTERVAL '6 month');

      UPDATE ss_libchats_flags
      SET user_type=
      (CASE
        WHEN initial_question LIKE '%visitor%' or transcript LIKE '%visitor'
          THEN 'Visitor'
        WHEN initial_question LIKE '%alum%' OR initial_question LIKE '%alumna%' OR initial_question LIKE '%alumni%' or transcript LIKE '%alum%' OR transcript LIKE '%alumna%' OR transcript LIKE '%alumni%'
          THEN 'Alumni'
        WHEN initial_question LIKE '%student%'
          THEN 'Student'
        WHEN initial_question LIKE '%faculty%' OR initial_question LIKE '%staff%' OR initial_question LIKE '%prof%' OR initial_question LIKE '%professor%'
          THEN 'Faculty'
      END);

      UPDATE ss_libchats_flags
      SET newspaper=1
      WHERE initial_question LIKE '%news%' OR initial_question LIKE '%newspaper%' OR initial_question LIKE '%Newspaper%' OR initial_question LIKE '%NYT%' OR initial_question LIKE '%News%' OR initial_question LIKE '%New York Times%' OR initial_question LIKE '%Philadelphia Inquirer%';

      UPDATE ss_libchats_flags
      SET medium=
      ( CASE
            WHEN initial_question LIKE '%book%'
              THEN 1
            WHEN initial_question LIKE '%article%' OR initial_question LIKE '%journal%'
              THEN 2
            WHEN initial_question LIKE '%music%'
              THEN 3
            WHEN initial_question LIKE '%microfilm%'
              THEN 4
            WHEN (initial_question LIKE '%film%' OR initial_question LIKE '%movie%') AND initial_question NOT LIKE '%microfilm%'
              THEN 5
            ELSE 0
        END );

      UPDATE ss_libchats_flags
      SET top_searches=
      ( CASE
            WHEN initial_question LIKE '%poster%' OR initial_question LIKE '%print%' OR initial_question LIKE '%printing%'
              THEN 1
            WHEN initial_question LIKE '%cite%' OR initial_question LIKE '%citation%'
              THEN 2
            ELSE 0
        END );

      UPDATE ss_libchats_flags
      SET services=
      ( CASE
            WHEN initial_question LIKE '%Interlibrary Loan%' OR initial_question LIKE '%interlibrary loan%' OR initial_question LIKE '%ILL%' OR initial_question LIKE '%Illiad%'
              THEN 1
            WHEN initial_question LIKE '%Franklin%' OR initial_question LIKE '%library website%' OR initial_question LIKE '%catalogue%' OR initial_question LIKE '%catalog%' OR initial_question LIKE '%FIND%'
              THEN 2
            ELSE 0
        END );

      UPDATE ss_libchats_flags
      SET account_q=
      ( CASE
            WHEN initial_question LIKE '%account%' OR initial_question LIKE '%pennkey%'
              THEN 1
            WHEN initial_question LIKE '%fine%' OR initial_question LIKE '%renew%' OR initial_question LIKE '%overdue%' OR initial_question LIKE '%fee%' OR initial_question LIKE '%fees%'
              THEN 2
            WHEN initial_question LIKE '%physical%' OR initial_question LIKE '%physically%' OR initial_question LIKE '%check out%' OR initial_question LIKE '%return%' OR initial_question LIKE '%pick up%' OR initial_question LIKE '%borrow%' OR initial_question LIKE '%rent%'
              THEN 3
            WHEN initial_question LIKE '%equipment%' OR initial_question LIKE '%laptop%' OR initial_question LIKE '%camera%' OR initial_question LIKE '%monitor%' OR initial_question LIKE '%speaker%'
              THEN 4
            ELSE 0
        END );

      UPDATE ss_libchats_flags
      SET subscription_issues=
      ( CASE
            WHEN initial_question LIKE '%subscription%'
              THEN 1
            WHEN initial_question LIKE '%access%'
              THEN 2
            WHEN initial_question LIKE '%log in%' OR initial_question LIKE '%logged in%' OR initial_question LIKE '%sign in%' OR initial_question LIKE '%signed in%'
              THEN 3
            ELSE 0
        END );

      UPDATE ss_libchats_flags
      SET type_of_search=
      ( CASE
            WHEN initial_question LIKE '%research%' OR initial_question LIKE '%researcher%'
              THEN 1
            WHEN initial_question LIKE '%class%' OR initial_question LIKE '%course%'
              THEN 2
            WHEN initial_question LIKE '%librarian%'
              THEN 3
            WHEN initial_question LIKE '%dissertation%' OR initial_question LIKE '%thesis%'
              THEN 4
            WHEN initial_question LIKE '%database%' OR initial_question LIKE '%software%'
              THEN 5
            WHEN (initial_question LIKE '%find%' OR initial_question LIKE 'search') AND initial_question NOT LIKE '%research%'
              THEN 6
            WHEN initial_question LIKE '%local%' OR initial_question LIKE '%community%' OR initial_question LIKE '%Philadelphia%' OR initial_question LIKE '%Philly%'
              THEN 7
            ELSE 0
        END );

      UPDATE ss_libchats_flags
      SET top_referrer=
      ( CASE
            WHEN referrer ILIKE 'https://www.library.upenn.edu/'
              THEN 'Homepage'
            WHEN referrer LIKE '%franklin%'
              THEN 'Franklin'
            WHEN referrer LIKE '%guide%'
              THEN 'Guide'
            WHEN referrer LIKE '%faq'
              THEN 'FAQ'
            WHEN referrer LIKE '%proxy%'
              THEN 'Proxy'
            WHEN referrer LIKE '%find%'
              THEN 'Find'
            WHEN referrer LIKE '%summon%'
              THEN 'Summon'
            WHEN referrer LIKE '%vanpelt%'
              THEN 'Van Pelt'
            WHEN referrer LIKE '%holman%'
              THEN 'Holman'
            WHEN referrer LIKE '%lippincott%'
              THEN 'Lippincott'
      END);
    SQL
    
    ActiveRecord::Base.connection.execute(query)
  end

  #Similar to update_demographics for Libanswers, written by KG.
  def self.update_demographics
    # SQL query to update demographic information based on either pennkey or email, depending on which was given
    query = <<-SQL
      UPDATE ss_libchats_flags
      SET (
        statistical_category_1,
        statistical_category_2,
        statistical_category_3,
        statistical_category_4,
        statistical_category_5,
        user_group,
        school,
        penn_id,
        pennkey
      ) = (
        upenn_alma_demographics.statistical_category_1,
        upenn_alma_demographics.statistical_category_2,
        upenn_alma_demographics.statistical_category_3,
        upenn_alma_demographics.statistical_category_4,
        upenn_alma_demographics.statistical_category_5,
        COALESCE(upenn_alma_demographics.user_group, 'Unknown'),
        COALESCE(upenn_alma_demographics.school, 'Unknown'),
        upenn_alma_demographics.penn_id,
        upenn_alma_demographics.pennkey
      )
      FROM upenn_alma_demographics
      WHERE
        ss_libchats_flags.contact_info LIKE '%upenn%'
        AND upenn_alma_demographics.pennkey = 
          SPLIT_PART(ss_libchats_flags.contact_info, '@', '1')
        OR ss_libchats_flags.name LIKE '%upenn%'
        AND upenn_alma_demographics.pennkey = 
          SPLIT_PART(ss_libchats_flags.name, '@', '1');

    SQL
    
    # Execute the raw SQL
    ActiveRecord::Base.connection.execute(query)

    ss_libchats_inquirymap = Springshare::Libchats::Flags

    test_chats=ss_libchats_inquirymap.where.not(user_group: "Unknown").or(ss_libchats_inquirymap.where.not(user_group: nil)).all
    
    #Now update the accompanying flags:
    for chat in test_chats
        if chat.user_group.eql?("Undergraduate Student")
           chat.user_type="Student"
        elsif chat.user_group.eql?("Grad Student")
           chat.user_type="Student"  
        elsif chat.user_group.eql?("Alumni") 
           chat.user_type="Alumni"
        elsif chat.user_group.eql?("Staff")
          chat.user_type="Faculty"
        elsif chat.user_group.eql?("Faculty")
          chat.user_type="Faculty"
        elsif chat.user_group.eql?("Faculty Express")
          chat.user_type="Faculty"
        end
        chat.save
    end      
  end
  
  def self.update_sentiment

    ss_libchats_inquirymap = Springshare::Libchats::Flags
    librarians=ss_libchats_inquirymap.distinct.order(:answerer).pluck(:answerer)
    
    #Make sure only the chats without a calculated sentiment score are involved in this labeling.
    #Also make sure none of the nil transcripts gets selected here.
    all_chats=ss_libchats_inquirymap.where(sentiment_score: nil).where.not(transcript: nil).all
    
    #Tokenize into words so can identify where ":"'s are:
    for entry in all_chats

      if not entry.transcript == nil
        sep_entry=entry.transcript&.split("\n")
      else
        sep_entry=""
      end

      user_transcript=Array.new

      if sep_entry != "" and sep_entry != nil
        for line in sep_entry

            switch=0
            #Need to double check that it's not a librarian:
            if line.include?(entry.answerer)==true
               switch=1
            end  
            
            if switch==0
               if line.include?(":")
                  if line.split(':').length >= 3
                     #Split after the timestamp:  
                     user_transcript.push(line.split(':')[2..].join(" "))
                  end  
               end
            end
            
         end  
      end

      #All compounds keeps the compound score for *every* user line.
      all_compounds=Array.new

      if user_transcript != Array.new
         for user_line in user_transcript
             user_sentiment=VaderSentimentRuby.polarity_scores(user_line)
             all_compounds.push(user_sentiment['compound'.to_sym])
         end
      end

      print all_compounds
      
      if all_compounds==Array.new
         avg_compound=0
      else 
         puts all_compounds.length
         avg_compound=all_compounds.sum/all_compounds.length
      end  
      
      entry.sentiment_score = avg_compound
      if avg_compound <= -0.05
         entry.sentiment = "Negative"
      elsif avg_compound > -0.05 and avg_compound < 0.05
         entry.sentiment = "Neutral"
      elsif avg_compound >= 0.05 and avg_compound < 0.3
         entry.sentiment = "Positive"
      elsif avg_compound >= 0.3
         entry.sentiment = "Ecstatic"
      end
      entry.save
    end  
  end
  
  # Function to auto update tables after upload via file import tool
  def self.update_after_import

    self.update_flags
    self.update_demographics
    self.update_sentiment
    
  end
end


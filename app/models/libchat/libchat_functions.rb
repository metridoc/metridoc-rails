class Springshare::Libchat::Flags < Springshare::Libchat::Base

#Put columns to privatize here:
  
    self.superadmin_columns = [
    :name, :contact_info, :ip, :answerer, :timestamp, :user_field_1, :user_field_2, :user_field_3, :initial_question, :internal_note, :transcript
  ]
  
#Some notes:

#Sounds like Karin wants all the columns available to us...so modify the table and hide the columns from everyone but admins...think that already happens with the ignored columns and the calls below...double check later! .
  
#Add the following columns:
#One conflict: want to hide penn_id and pennkey, but not initially a column in the table...where to put the superadmin call then/how to privatize? Can I just add to the end of the migration and have it fill with nulls? Need to confirm...
#Think that's going to be dependent on how KG is reading these files in? Ask?
    
  def self.update_flags
    query= <<-SQL

      ALTER TABLE Libchats
      ADD visitor_q BOOL,
      ADD alumni_q BOOL,
      ADD faculty_staff_q BOOL,
      ADD student_q BOOL,
      ADD sentiment_score FLOAT(4),
      ADD sentiment CHAR(50),
      ADD newspaper BOOL,
      ADD medium SMALLINT,
      ADD top_searches SMALLINT,
      ADD services SMALLINT,
      ADD account_q SMALLINT,
      ADD subscription_issues SMALLINT,
      ADD type_of_search SMALLINT,
      ADD statistical_category_1 CHAR(50),
      ADD statistical_category_2 CHAR(50),
      ADD statistical_category_3 CHAR(50),
      ADD statistical_category_4 CHAR(50),
      ADD statistical_category_5 CHAR(50),
      ADD user_group CHAR(50),
      ADD school CHAR(50),
      ADD penn_id CHAR(50),
      ADD pennkey CHAR(50);

      UPDATE Libchats
      SET visitor_q=1
      WHERE Initial Question LIKE '%visitor%';

      UPDATE Libchats
      SET alumni_q=1
      WHERE Initial Question LIKE '%alum%' OR Initial Quesiton LIKE '%alumna%' OR Initial Question LIKE '%alumni%';

      UPDATE Libchats
      SET faculty_staff_q=1
      WHERE Initial Question LIKE '%faculty%' OR Initial Question LIKE '%staff%' OR Initial Question LIKE '%prof%' OR Initial Question LIKE '%professor%';

      UPDATE Libchats
      SET student_q=1
      WHERE Initial Question LIKE '%student%';

      UPDATE Libchats
      SET newspaper=1
      WHERE Initial Question LIKE '%news%' OR Initial Question LIKE '%newspaper%' OR Initial Question LIKE '%Newspaper%' OR Initial Question LIKE '%NYT%' OR Initial Question LIKE '%News%' OR Initial Question LIKE '%New York Times%';

      UPDATE Libchats
      SET medium=
      ( CASE
            WHEN Initial Question LIKE '%book%'
              THEN 1
            WHEN Initial Question LIKE '%article%' OR Initial Question '%journal%'
              THEN 2
            WHEN Initial Question LIKE '%music%'
              THEN 3
            WHEN Initial Question LIKE '%microfilm%'
              THEN 4
            WHEN (Initial Question LIKE '%film%' OR Initial Question LIKE '%movie%') AND Initial Question NOT LIKE '%microfilm%'
              THEN 5
            ELSE 0
        END );

      UPDATE Libchats
      SET top_searches=
      ( CASE
            WHEN Initial Question LIKE '%poster%' OR Initial Question LIKE '%print%' OR Initial Question LIKE '%printing%'
              THEN 1
            WHEN Initial Question LIKE '%cite%' OR Initial Question LIKE '%citation%'
              THEN 2
            ELSE 0
        END );

      UPDATE Libchats
      SET services=
      ( CASE
            WHEN Initial Question LIKE '%Interlibrary Loan%' OR Initial Question LIKE '%interlibrary loan%' OR Initial Question LIKE '%ILL%' OR Initial Question LIKE '%Illiad%'
              THEN 1
            WHEN Initial Question LIKE '%Franklin%' OR Initial Question LIKE '%library website%'
              THEN 2
            ELSE 0
        END );

      UPDATE Libchats
      SET account_q=
      ( CASE
            WHEN Initial Question LIKE '%account%' OR Initial Question LIKE '%pennkey%'
              THEN 1
            WHEN Initial Question LIKE '%fine%' OR Initial Question LIKE '%renew%' OR Initial Question LIKE '%overdue%' OR Initial Question LIKE '%fee%' OR Initial Question LIKE '%fees%'
              THEN 2
            WHEN Initial Question LIKE '%physical%' OR Initial Question LIKE '%physically%' OR Initial Question LIKE '%check out%' OR Initial Question LIKE '%return%' OR Initial Question LIKE '%pick up%' OR Initial Question LIKE '%borrow%' OR Initial Question LIKE '%rent%'
              THEN 3
            WHEN Initial Question LIKE '%equipment%' OR Initial Question LIKE '%laptop%' OR Initial Question LIKE '%camera%' OR Initial Question LIKE '%monitor%' OR Initial Question LIKE '%speaker%'
              THEN 4
            ELSE 0
        END );

      UPDATE Libchats
      SET subscription_issues=
      ( CASE
            WHEN Initial Question LIKE '%subscription%'
              THEN 1
            WHEN Initial Question LIKE '%access%'
              THEN 2
            WHEN Initial Question LIKE '%log in%' OR Initial Question LIKE '%logged in%' OR Initial Question LIKE '%sign in%' OR Initial Question LIKE '%signed in%'
              THEN 3
            ELSE 0
        END );

      UPDATE Libchats
      SET type_of_search=
      ( CASE
            WHEN Initial Question LIKE '%research%' OR Initial Question LIKE '%researcher%'
              THEN 1
            WHEN Initial Question LIKE '%class%' OR Initial Question LIKE '%course%'
              THEN 2
            WHEN Initial Question LIKE '%librarian%'
              THEN 3
            WHEN Initial Question LIKE '%dissertation%' OR Initial Question LIKE '%thesis%'
              THEN 4
            WHEN Initial Question LIKE '%database%' OR Initial Question LIKE '%software%'
              THEN 5
            WHEN (Initial Question LIKE '%find%' OR Initial Question LIKE 'search') AND Initial Question NOT LIKE '%research%'
              THEN 6
            WHEN Initial Question LIKE '%local%' OR Initial Question LIKE '%community%' OR Initial Question LIKE '%Philadelphia%' OR Initial Question LIKE '%Philly%'
              THEN 7
            ELSE 0
        END );
    SQL

    ActiveRecord::Base.connection.execute(query)
  end

  #Similar to update_demographics for Libanswers, written by KG.
  
  def self.update_demographics
    # SQL query to update demographic information based on either pennkey or email, depending on which was given
    query = <<-SQL
      UPDATE libchats
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
        (libchat.email LIKE '%upenn%'
        AND upenn_alma_demographics.pennkey = 
          SPLIT_PART(libchat.email, '@', '1'))
        OR (libchat.name LIKE '%upenn%'
        AND upenn_alma_demographics.pennkey = 
          SPLIT_PART(libchat.email, '@', '1'))
        OR (upenn_alma_demographics.pennkey = libchat.name)
    SQL

    # Execute the raw SQL
    ActiveRecord::Base.connection.execute(query)

    #Now update the accompanying flags:
    for index in (0..libchat.chat_id.length).to_a
        if libchat.user_group=="Undergraduate Student" or libchat.user_group=="Grad Student"
           student_q=1
        elsif libchat.user_group=="Alumni" #double check that this is correct...
           alumni_q=1
        elsif libchat.user_group=="Staff" or libchat.user_group=="Faculty"
           faculty_staff_q=1
        end  
    end  
  end

#These are the three categories that are relevant, not sure what the "alum" entry looks like in alma though...
#Also look up tomorrow?

=begin
   UPDATE Libchats
      SET alumni_q=1
      WHERE Initial Question LIKE '%alum%' OR Initial Quesiton LIKE '%alumna%' OR Initial Question LIKE '%alumni%';

      UPDATE Libchats
      SET faculty/staff_q=1
      WHERE Initial Question LIKE '%faculty%' OR Initial Question LIKE '%staff%' OR Initial Question LIKE '%prof%' OR Initial Question LIKE '%professor%';

      UPDATE Libchats
      SET student_q=1
      WHERE Initial Question LIKE '%student%';
=end    
  
  def self.update_sentiment
    
    transcript=libchat.select(:transcript)
    id=libchat.select(:chat_id)
    
    #Need to double check that it's not a librarian:
    Librarians=["Mercy Ayilo", "David Azzolina", "Mary Kate Baker", "Marcella Barnhart", "Alexandra Bartley", "Elizabeth Blake", "Megan Brown", "Michael Carroll", "Melanie Cedrone", "Charles Cobine", "Claire Cornelius","Sarabeth Coyle", "Cynthia Cronin-Kardon", "Mia D'Avanza", "Mety Damte", "Alisha Davis", "Phebe Dickson", "Rory Duffy", "Bethany Falcon", "Gwen Fancy", "Anna-Alexandra Fodde-Reguer", "Brie Gettleson", "Alexandrea Glenn", "Larissa Gordon", "Stephen Hall", "Joe Holub", "Heather Hughes", "Lonya Humphrey", "Madison Jurgens", "Aman Kaur","Sam Kirk", "Connie Kolakowski", "Varvara (Barbara) Kountouzi", "Lippincott Library", "Margy Lindem", "Nicole Mackowiak", "Allison Madar", "Doug McGee", "Rebecca Mendelson", "Nick Okrent", "Kirsten Painter", "Natalie Pendergast", "Mayelin Perez", "Bob Persing", "Jef Pierce", "Dot Porter", "Katie Rawson", "Oliver Seifert-Gram", "Alexandra Servey", "Matthew Sharp", "Erin Sharwell", "Rebecca Stuhr", "Victoria Sun", "Kevin Thomas", "Joanna Thompson", "Matthew Trowbridge", "Liza Vick", "Brian Vivier", "Mia Wells", "Holly Zerbe"]
  
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
        
        for name in Librarians
          if name in sep_entry
             switch=1
          end

          if switch==1:
             next
          elsif switch==0
             transcript.push(sep_entry.split(':')[3:-1])
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
      
      entry_to_edit=libchats.find(chatid: id[id_sel])
      entry_to_edit.sentiment_score.edit = avg_compound
      if avg_compound < = -0.05
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

  # Function to auto update tables after upload via file import tool
  def self.update_after_import

    self.update_flags
    self.update_demographics
    self.update_sentiment
    
  end
end

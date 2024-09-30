class Springshare::Libchats::Flags < Springshare::Libchats::Base

#Put columns to privatize here:
  
  def self.superadmin_columns
  [
    "name", "contact_info", "ip", "answerer", "timestamp", "user_field_1", "user_field_2", "user_field_3", "initial_question", "internal_note", "transcript"
  ]
  end

  #Not sure if I need or not?
  def self.alternate_id
    "chat_id"
  end

  # Should only activate when they've already been read in...for now just set for the first functions flags, might need to add others later?

  #def self.on_conflict_update 
  #  {
  #    conflict_target: [:chat_id],
  #    columns: [
  #      :visitor_q,
  #      :alumni_q,
  #      :faculty_staff_q,
  #      :student_q,
  #      :sentiment_score,
  #      :sentiment,
  #      :newspaper,
  #      :medium,
  #      :top_searches,
  #      :services,
  #      :account_q,
  #      :subscription_issues,
  #      :type_of_search,
  #      :statistical_category_1,
  #      :statistical_category_2,
  #      :statistical_category_3,
  #      :statistical_category_4,
  #      :statistical_category_5,
  #      :user_group,
  #      :school,
  #      :penn_id,
  #      :pennkey
  #    ]
  #  }
  #end
  
#Some notes:

#Sounds like Karin wants all the columns available to us...so modify the table and hide the columns from everyone but admins...think that already happens with the ignored columns and the calls below...double check later! .
  
#Add the following columns:
#One conflict: want to hide penn_id and pennkey, but not initially a column in the table...where to put the superadmin call then/how to privatize? Can I just add to the end of the migration and have it fill with nulls? Need to confirm...
#Think that's going to be dependent on how KG is reading these files in? Ask?
    
  def self.update_flags
    query= <<-SQL

      ALTER TABLE ss_libchats_flags
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
      ADD penn_id CHAR(8),
      ADD pennkey CHAR(8);

      UPDATE ss_libchats_flags
      SET visitor_q=true
      WHERE initial_question LIKE '%visitor%';

      UPDATE ss_libchats_flags
      SET alumni_q=true
      WHERE initial_question LIKE '%alum%' OR initial_question LIKE '%alumna%' OR initial_question LIKE '%alumni%';

      UPDATE ss_libchats_flags
      SET faculty_staff_q=true
      WHERE initial_question LIKE '%faculty%' OR initial_question LIKE '%staff%' OR initial_question LIKE '%prof%' OR initial_question LIKE '%professor%';

      UPDATE ss_libchats_flags
      SET student_q=true
      WHERE initial_question LIKE '%student%';

      UPDATE ss_libchats_flags
      SET newspaper=true
      WHERE initial_question LIKE '%news%' OR initial_question LIKE '%newspaper%' OR initial_question LIKE '%Newspaper%' OR initial_question LIKE '%NYT%' OR initial_question LIKE '%News%' OR initial_question LIKE '%New York Times%';

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
            WHEN initial_question LIKE '%Franklin%' OR initial_question LIKE '%library website%' OR initial_question LIKE '%catalogue%' OR initial_question LIKE '%FIND%'
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
          SPLIT_PART(ss_libchats_flags.name, '@', '1')
        OR upenn_alma_demographics.pennkey = ss_libchats_flags.name
    SQL

    # Execute the raw SQL
    ActiveRecord::Base.connection.execute(query)
    
  end

  # Function to auto update tables after upload via file import tool
  def self.update_after_import

    self.update_flags
    self.update_demographics
    #self.update_sentiment
    
  end
end

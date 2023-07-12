module GatecountHelper

#Library options are "Van Pelt", "Biotech", "Furness", "All"
#Student type= "Grad Student" or "Undergraduate Student"
  
  def library_table
      output_table=GateCount::CardSwipe.select(
        "SELECT
           school,
           user_group,
           CASE
             WHEN door_name LIKE 'VAN PELT%'
               THEN 'Van Pelt'
             WHEN door_name LIKE 'FURNESS%'
               THEN 'Furness'
             WHEN door_name LIKE 'BIO%'
               THEN 'Biotech'
           END AS library,
           DATE_PART('year', swipe_date + INTERVAL '6 month') AS fiscal_year,
           COUNT(card_num) AS num_swipes, 
           COUNT(DISTINCT card_num) AS num_people  
         FROM gate_count_card_swipes 
         WHERE
           user_group='Grad Student' OR user_group='Undergraduate Student'
           AND door_name IN ('VAN PELT LIBRARY ADA DOOR_ *VPL', 'VAN PELT LIBRARY TURN1_ *VPL', 'VAN PELT LIBRARY TURN2_ *VPL', 'VAN PELT LIBRARY USC HANDICAP ENT VERIFY_ *VPL', 'FURNESS TURNSTILE_ *FUR', 'BIO LIBRARY TURNSTILE GATE_ *JSN')         GROUP BY 1, 2, 3, 4;")
      
    puts output_table.where(school:'College of Arts & Sciences')

  end

  #def enrollment_table(user_group,first_year,last_year)
  #  pop_table=Upenn::Enrollment.connection.select_all(
  #    "SELECT
  #       school
  #       value
  #       fiscal_year
  #     FROM upenn_enrollments
  #       WHERE user_group='Graduate Total'
  #         AND ((EXTRACT(year from swipe_date)=? AND EXTRACT(month from swipe_date) <=5)\
  #  OR (EXTRACT(year from swipe_date)=? AND EXTRACT(month from swipe_date) >=6))",last_year,first_year)

  #pop_table.rows
    
  #def undergrad_counts(input_table,fiscal_year)
    
  #end
    
  #def graduate_counts(input_table,fiscal_year)

  #end
  
end  

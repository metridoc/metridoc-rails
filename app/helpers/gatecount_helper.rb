module GatecountHelper

#Library options are "Van Pelt", "Biotech", "Furness", "All"
#Student type= "Grad Student" or "Undergraduate Student"
  
  def library_table
      output_table=GateCount::CardSwipe.connection.select_all(
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

      pop_stats=output_table.to_a
      return pop_stats
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
    

  def gen_stats(input_table,fiscal_year,library)
   #Delete unnecessary data and data from wrong schools:
   gen_values=input_table.delete_if{|h| h["fiscal_year"]!=fiscal_year || |h| h["school"]!="Penn Libraries" || |h| h["fiscal_year"]!="Social Policy & Practice"}
   if library="Biotech"
      gen_values=gen_values.delete_if{|h| h["library"] == "Van Pelt" || h["library"] == "Furness"}
   elsif library="Furness"
      gen_values=gen_values.delete_if{|h| h["library"] == "Van Pelt" || h["library"] == "Biotech"}
   elif library="Van Pelt"
      gen_values=gen_values.delete_if{|h| h["library"] == "Furness" || h["library"] == "Biotech"}
    end
    
  end

  def calc_percents(input_table,type,user_group)
    input_table.delete_if{|h| h["user_group"] != user_group}
    if type=="Counts"
     num_swipes=input_table.pluck("num_swipes")
     all_swipes=num_swipes.sum 
     percents=num_swipes.map {|x|  (x).fdiv(all_swipes)}
     
    elsif type=="People"  
      num_people=input_table.pluck("num_people")
      all_people=num_people.sum
      percents=num_people.map {|x|  (x).fdiv(all_people)}       
    end

    schools=input_table.pluck("school")
    
    percents_array=[]

    percent_index=(0..percents.length-1).to_a

    #This puts it back into an array of hashes, which is *not* what I want!
    percent_index.each {|i| percents_array << [schools[i], percents[i]]}

    puts percents_array
    
    return percents_array
  end
   
end  

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

      return output_table.to_a
  end

  def enrollment_table(user,fiscal_year)
    pop_table=Upenn::Enrollment.connection.select_all(
      "SELECT
         school
         value
       FROM upenn_enrollments
         WHERE user_group=?
           AND ((EXTRACT(year from swipe_date)=? AND EXTRACT(month from swipe_date) <=5)\
           OR (EXTRACT(year from swipe_date)=? AND EXTRACT(month from swipe_date) >=6))",user,fiscal_year,fiscal_year-1)

    return pop_table.to_a

  end  

  def gen_stats(input_table,fiscal_year,library)
    #Delete unnecessary data and data from wrong schools:
    copy_table=input_table
    gen_values=copy_table.delete_if{|h| h["fiscal_year"]!=fiscal_year}
    #This breaks it for some reason...
    #|| h["school"]="Penn Libraries" || h["school"]="Social Policy & Practice"}
   if library=="Biotech"
      gen_values=gen_values.delete_if{|h| h["library"] == "Van Pelt" || h["library"] == "Furness"}
   elsif library=="Furness"
      gen_values=gen_values.delete_if{|h| h["library"] == "Van Pelt" || h["library"] == "Biotech"}
   elsif library=="Van Pelt"
     gen_values=gen_values.delete_if{|h| h["library"] == "Furness" || h["library"] == "Biotech"}
     puts gen_values
   #Need to actually combine the values...but not sure that we want this...
   #else library=="All"
   #  puts "All Libraries"
   return gen_values
   end
    
  end

  def calc_percents(input_table,type,user_group)
    copy_table=input_table
    copy_table.delete_if{|h| h["user_group"] != user_group}
    if type=="Counts"
     num_swipes=copy_table.pluck("num_swipes")
     all_swipes=num_swipes.sum 
     percents=num_swipes.map {|x|  (x).fdiv(all_swipes)}

    #These are not the right numbers...need the enrollments table! 
    elsif type=="People"  
      num_people=copy_table.pluck("num_people")
      all_people=num_people.sum
      percents=num_people.map {|x|  (x).fdiv(all_people)}       
    end

    schools=copy_table.pluck("school")
    
    percents_array=[]

    percent_index=(0..percents.length-1).to_a

    #This puts it back into an array of hashes, which is *not* what I want!
    percent_index.each {|i| percents_array << [schools[i], percents[i]]}
    
    return percents_array
  end
   
end  

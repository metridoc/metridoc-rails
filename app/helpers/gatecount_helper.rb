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
           WHERE (user_group='Grad Student' OR user_group='Undergraduate Student')
              AND door_name IN ('VAN PELT LIBRARY ADA DOOR_ *VPL', 'VAN PELT LIBRARY TURN1_ *VPL', 'VAN PELT LIBRARY TURN2_ *VPL', 'VAN PELT LIBRARY USC HANDICAP ENT VERIFY_ *VPL', 'FURNESS TURNSTILE_ *FUR', 'BIO LIBRARY TURNSTILE GATE_ *JSN')         GROUP BY 1, 2, 3, 4
            ORDER BY COUNT(card_num);")

      return output_table.to_a
  end

  def time_table
      output_table=GateCount::CardSwipe.connection.select_all(
        "SELECT
           CASE
             WHEN door_name LIKE 'VAN PELT%'
               THEN 'Van Pelt'
             WHEN door_name LIKE 'FURNESS%'
               THEN 'Furness'
             WHEN door_name LIKE 'BIO%'
               THEN 'Biotech'
           END AS library,
           DATE_PART('year', swipe_date + INTERVAL '6 month') AS fiscal_year,
           EXTRACT(month from swipe_date) AS month,
           COUNT(card_num) AS num_swipes, 
           COUNT(DISTINCT card_num) AS num_people
         FROM gate_count_card_swipes 
           WHERE door_name IN ('VAN PELT LIBRARY ADA DOOR_ *VPL', 'VAN PELT LIBRARY TURN1_ *VPL', 'VAN PELT LIBRARY TURN2_ *VPL', 'VAN PELT LIBRARY USC HANDICAP ENT VERIFY_ *VPL', 'FURNESS TURNSTILE_ *FUR', 'BIO LIBRARY TURNSTILE GATE_ *JSN')
         GROUP BY 1,2,3;")

      return output_table.to_a
  end

   def freq_table
      output_table=GateCount::CardSwipe.connection.select_all(
        "SELECT
           CASE
             WHEN door_name LIKE 'VAN PELT%'
               THEN 'Van Pelt'
             WHEN door_name LIKE 'FURNESS%'
               THEN 'Furness'
             WHEN door_name LIKE 'BIO%'
               THEN 'Biotech'
           END AS library,
           DATE_PART('year', swipe_date + INTERVAL '6 month') AS fiscal_year,
           EXTRACT(week from swipe_date) AS week,
           card_num,
           COUNT(card_num) AS num_swipes,
           COUNT(DISTINCT card_num) AS num_people
         FROM gate_count_card_swipes 
           WHERE school='College of Arts & Sciences'
              AND door_name IN ('VAN PELT LIBRARY ADA DOOR_ *VPL', 'VAN PELT LIBRARY TURN1_ *VPL', 'VAN PELT LIBRARY TURN2_ *VPL', 'VAN PELT LIBRARY USC HANDICAP ENT VERIFY_ *VPL', 'FURNESS TURNSTILE_ *FUR', 'BIO LIBRARY TURNSTILE GATE_ *JSN')
         GROUP BY 1,2,3,4;")

      return output_table.to_a
  end
  
  def enrollment_table #(user,fiscal_year)
    pop_table=Upenn::Enrollment.connection.select_all(
      "SELECT
         school,
         value
       FROM upenn_enrollments;")
       #  WHERE user_group=?
       #    AND ((EXTRACT(year from swipe_date)=? AND EXTRACT(month from swipe_date) <=5)\
       #    OR (EXTRACT(year from swipe_date)=? AND EXTRACT(month from swipe_date) >=6))",user,fiscal_year,fiscal_year-1)

    schools=pop_table.to_a.pluck('school')
    value=pop_table.to_a.pluck('value')

    enrollments_array=Hash.new
    value_index=(0..value.length-1).to_a
    value_index.each {|i| enrollments_array[schools[i]] = value[i]}

    return enrollments_array
    
  end  

  def gen_stats(input_table,fiscal_year,library)
    #Delete unnecessary data and data from wrong schools:
    gen_values=input_table
    if fiscal_year.is_a? Integer
       gen_values=input_table.select{|h| h["fiscal_year"]==fiscal_year}
    end
    #This breaks it for some reason...
    #|| h["school"]="Penn Libraries" || h["school"]="Social Policy & Practice"}
    if library=="Biotech"
       gen_values=gen_values.delete_if{|h| h["library"] == "Van Pelt" || h["library"] == "Furness"}
    elsif library=="Furness"
       gen_values=gen_values.delete_if{|h| h["library"] == "Van Pelt" || h["library"] == "Biotech"}
    elsif library=="Van Pelt"
       gen_values=gen_values.delete_if{|h| h["library"] == "Furness" || h["library"] == "Biotech"}
   #Need to actually combine the values...but not sure that we want this...
   #else library=="All"
     #  puts "All Libraries"
    end
   
    return gen_values
    
  end

  def calc_percents(input_table,type,user_group)
    if user_group != "All"
      copy_table=input_table.select{|h| h["user_group"] == user_group}
    elsif
      copy_table=input_table
    end
    
    if type=="Counts"
     num_swipes=copy_table.pluck("num_swipes")
     all_swipes=num_swipes.sum 
     percents=num_swipes.map {|x| (x).fdiv(all_swipes)}

    #These are not the right numbers...need the enrollments table! 
    elsif type=="People"  
      num_people=copy_table.pluck("num_people")
      all_people=num_people.sum
      percents=num_people.map {|x| (x).fdiv(all_people)}

    elsif type=="Raw Counts"
      percents=copy_table.pluck("num_swipes")
    elsif type=="Individuals"
      percents=copy_table.pluck("num_people")
    end

    schools=copy_table.pluck("school")
    
    percents_array=Hash.new
    percent_index=(0..percents.length-1).to_a
    percent_index.each {|i| percents_array[schools[i]] = percents[i]}
    
    return percents_array
    
  end

  def time_counts(input_table,time_frame,count_type)
    
      copy_table=input_table

      if time_frame=="Weekly"
        time=copy_table.pluck("week")
      elsif time_frame=="Monthly"
        time=copy_table.pluck("month")    
      elsif time_frame=="Yearly" 
        time=copy_table.pluck("fiscal_year")
      elsif time_frame=="All"
        time=input_table.pluck("fiscal_year")
      end
      
      if count_type=="Counts"
         count=copy_table.pluck("num_swipes")
      elsif count_type=="People"
         count=input_table.pluck("num_people")
      end

      
      month_names=["January","February","March","April","May","June","July","August","September","October","November","December"]
      
      temp_array=Hash.new
      count_array=Hash.new

      temp_index=[6,7,8,9,10,11,0,1,2,3,4,5]
      count_index=(0..count.length-1).to_a

      if time_frame=="Monthly"
         count_index.each {|i| temp_array[month_names[time[i].to_i-1]] = count[i]}
      else
         count_index.each {|i| count_array[time[i]] = count[i]}
      end

      #Reordering to the fiscal year:
      if time_frame=="Monthly"
        temp_index.each {|i| count_array[month_names[i]]=temp_array[month_names[i]]}
      end

      if time_frame=="Yearly"
         years=time
        
         year_range=[2016,2017,2018,2019,2020,2021,2022,2023]

         year_index=[0,1,2,3,4,5,6,7]
         
         for i in year_index
             year_data=copy_table.select{|h| h["fiscal_year"] == year_range[i]}
             year_counts=year_data.pluck('num_swipes').sum
             
             count_array["#{year_range[i]}"]=year_counts
         end
      end
      
      if time_frame=="All"
         years=time
        
         year_range=(years.min.to_i..years.max.to_i).to_a

         year_index=(0..year_range.length-1).to_a

         all_data=[]

         for i in year_index
             fiscal_year_data=copy_table.select{|h| h["fiscal_year"] == year_range[i]}
             fiscal_year_month=fiscal_year_data.pluck('month')
             fiscal_year_counts=fiscal_year_data.pluck('num_swipes')

             fiscal_array=Hash.new
             fiscal_index=(0..fiscal_year_counts.length-1).to_a
             fiscal_index.each {|i| fiscal_array[month_names[fiscal_year_month[i].to_i-1]] = fiscal_year_counts[i]}
             fiscal_array["Total"]=fiscal_year_counts.sum
             all_data << fiscal_array
         end

         puts all_data                                                                        
         return all_data
         
      end

      return count_array
  end
   
end

      #Need to get each bin for the frequency data:
      #if count_type=="Frequency"
      #   count=copy_table.pluck("num_swipes")
      #   people=copy_table.pluck("num_people")

      #   num_users=people.sum
         
      #   single_user=count.select{|h| h["count"] == user_group}
      #   medium_user=
      #   freq_user=
         
         #Need to remember to return as a percentage of the college of arts and sciences population
      #   total_pop=9303
         
      #   percents_zero.(num_users-single_user).fdiv(total_pop)
      #   percents_one=(single_user).fdiv(total_pop)
      #   percents_two=(medium_user).fdiv(total_pop)
      #   percents_three=(freq_user).fdiv(total_pop)

      #   freq_info=[percents_zero,percents_one,percents_two,percents_three]

      #   return freq_info
#      -for i in year_index
#        -data=vp_all_counts[i][month_names[m]]
#        %td="#{data}"
      

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
           WHERE door_name IN ('VAN PELT LIBRARY ADA DOOR_ *VPL', 'VAN PELT LIBRARY TURN1_ *VPL', 'VAN PELT LIBRARY TURN2_ *VPL', 'VAN PELT LIBRARY USC HANDICAP ENT VERIFY_ *VPL', 'FURNESS TURNSTILE_ *FUR', 'BIO LIBRARY TURNSTILE GATE_ *JSN')
              AND school != 'Penn Libraries' AND school != 'Social Policy & Practice'
              GROUP BY 1, 2, 3, 4
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
           AND school != 'Penn Libraries' AND school != 'Social Policy & Practice'
         GROUP BY 1,2,3;")

      return output_table.to_a
  end

   def freq_table
      output_table=GateCount::CardSwipe.connection.select_all(
        "SELECT
           school,
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
           card_num
         FROM gate_count_card_swipes 
              WHERE (EXTRACT(week from swipe_date) >= 1 AND EXTRACT(week from swipe_date) <= 26)
              AND (user_group='Undergraduate Student' OR user_group='Grad Student')
              AND door_name IN ('VAN PELT LIBRARY ADA DOOR_ *VPL', 'VAN PELT LIBRARY TURN1_ *VPL', 'VAN PELT LIBRARY TURN2_ *VPL', 'VAN PELT LIBRARY USC HANDICAP ENT VERIFY_ *VPL', 'FURNESS TURNSTILE_ *FUR', 'BIO LIBRARY TURNSTILE GATE_ *JSN')")

      return output_table.to_a
  end
  
  def enrollment_table(user) 
    pop_table=Upenn::Enrollment.connection.select_all(
      "SELECT
         school,
         value,
         fiscal_year
       FROM upenn_enrollments;")

    enrollments_array=[]
    fiscal_year=pop_table.to_a.pluck('fiscal_year')

    year_range=(fiscal_year.min.to_i..fiscal_year.max.to_i).to_a
    year_index=(0..year_range.length-1).to_a

    year_values=pop_table.to_a.select{|h| h["fiscal_year"]==2023}
    schools=year_values.pluck('school')
        
    yearly_enroll=Hash.new

    enrollments_array=[]

    enroll_names=['SAS','Wharton','Annenberg','Dental','Weitzman','Education','Engineering','Law','Perelman','Veterinary','Nursing','SP2']
        
    value_index=(0..enroll_names.length-1).to_a
    for i in value_index
        if user=="Total"
           #For some reason it hates when I try to select by user group so for now I'm just indexing the desired group.
           values=year_values.select{|h| h["school"]==enroll_names[i]}.pluck("value")[0]
        elsif user=="Undergrad"
           values=year_values.select{|h| h["school"]==enroll_names[i]}.pluck("value")[1]
        else
           values=year_values.select{|h| h["school"]==enroll_names[i]}.pluck("value")[4]
        end
        yearly_enroll[enroll_names[i]] = values
        enrollments_array << yearly_enroll
    end
    return enrollments_array
    
  end  

  def gen_stats(input_table,fiscal_year,library,school_type)
    #Delete unnecessary data and data from wrong schools:
    gen_values=input_table
    if fiscal_year.is_a? Integer
       gen_values=input_table.select{|h| h["fiscal_year"]==fiscal_year}
    end
    #This breaks it for some reason...so instead including in the SQL.
    #|| h["school"]="Penn Libraries" || h["school"]="Social Policy & Practice"}
    if library=="Biotech"
       gen_values=gen_values.select{|h| h["library"] == "Biotech"}
    elsif library=="Furness"
       gen_values=gen_values.select{|h| h["library"] == "Furness"}
    elsif library=="Van Pelt"
       gen_values=gen_values.select{|h| h["library"] == "Van Pelt"}        
    end

    if school_type != "All"
       gen_values=gen_values.select{|h| h["school"] == school_type}
    end
    
    return gen_values
    
  end

  def calc_percents(input_table,type,user_group)
    
    #type is one of four options:
    #1) "Counts" is the percentage of counts relative to the total population.
    #2) "People" is the percentage of people relative to the total population.
    #3) "Raw Counts" is just the number of counts, no percentages.
    #4) "Individuals" is the number of people, no percentages.
    
    if user_group != "All"
      copy_table=input_table.select{|h| h["user_group"] == user_group}
    elsif
      copy_table=input_table
    end
    
    if type=="Counts"
     num_swipes=copy_table.pluck("num_swipes")
     all_swipes=num_swipes.sum 
     percents=num_swipes.map {|x| (x).fdiv(all_swipes)}

    #These are the number of *users*, need enrollments for total school population. 
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

  def time_counts(input_table,time_frame,count_type,school_index=0)
    
      copy_table=input_table

      if time_frame=="Weekly"
        time=copy_table.pluck("week")
      elsif time_frame=="Monthly"
        time=copy_table.pluck("month")    
      elsif time_frame=="Yearly" || time_frame=="Fiscal_Year"
        time=copy_table.pluck("fiscal_year")
      elsif time_frame=="All"
        time=input_table.pluck("fiscal_year")
      end
      
      if count_type=="Counts"
         count=copy_table.pluck("num_swipes")
      elsif count_type=="People"
        count=input_table.pluck("num_people")
      elsif count_type=="Frequency"
        count=input_table.pluck("card_num")
      end

      if time_frame=="Fiscal_Year"
         years=time
        
         year_range=[2016,2017,2018,2019,2020,2021,2022,2023]

         year_index=[0,1,2,3,4,5,6,7]

         all_data=[]

         fiscal_data=Hash.new

         for y in year_index
             fiscal_year_data=copy_table.select{|h| h["fiscal_year"] == year_range[y]}
             fiscal_year_counts=fiscal_year_data.pluck('num_swipes').sum
             fiscal_year_people=fiscal_year_data.pluck('num_people').sum
             
             if count_type=="Counts"
                fiscal_data["#{year_range[y]}"] = fiscal_year_counts
             elsif count_type=="People"
                fiscal_data["#{year_range[y]}"] = fiscal_year_people
             end
         end
         return fiscal_data
      end
                                                                     
      month_names=["January","February","March","April","May","June","July","August","September","October","November","December"]

      month_text=["01","02","03","04","05","06","07","08","09","10","11","12"]
      
      temp_array=Hash.new
      count_array=Hash.new

      temp_index=[6,7,8,9,10,11,0,1,2,3,4,5]
      count_index=(0..count.length-1).to_a

      if time_frame=="Monthly"
         count_index.each {|i| temp_array[month_names[time[i].to_i-1]] = count[i]}
      end

      #Reordering to the fiscal year:
      if time_frame=="Monthly"
        temp_index.each {|i| count_array[month_names[i]]=temp_array[month_names[i]]}
      end
      
      if time_frame=="All" || time_frame=="Yearly"
         years=time
        
         year_range=(years.min.to_i..years.max.to_i).to_a

         year_index=(0..year_range.length-1).to_a

         all_data=[]

         yearly_data=Hash.new

         for y in year_index
             fiscal_year_data=copy_table.select{|h| h["fiscal_year"] == year_range[y]}
             fiscal_year_month=fiscal_year_data.pluck('month')
             fiscal_year_counts=fiscal_year_data.pluck('num_swipes')
             fiscal_year_people=fiscal_year_data.pluck('num_people')

             fiscal_array=Hash.new
             fiscal_index=(0..fiscal_year_counts.length-1).to_a
             if time_frame=="Yearly" && count_type=="Counts"
               for i in fiscal_index
                   #Here needs to actually be in the correct time order.
                   if fiscal_year_month[i] >= 7
                     yearly_data["#{year_range[y]-1}-"+month_text[fiscal_year_month[i].to_i-1]+"-01"] = fiscal_year_counts[i]
                   else
                     yearly_data["#{year_range[y]}-"+month_text[fiscal_year_month[i].to_i-1]+"-01"] = fiscal_year_counts[i]
                   end
                end
             elsif time_frame=="All"
                fiscal_index.each {|i| fiscal_array[month_names[fiscal_year_month[i].to_i-1]] = fiscal_year_counts[i]}
                fiscal_array["Total"]=fiscal_year_counts.sum
                fiscal_array["Statistics"]="Count"
                all_data << fiscal_array
             end
             
             fiscal_index=(0..fiscal_year_people.length-1).to_a
             if time_frame=="Yearly" && count_type=="People"
               for i in fiscal_index
                 if fiscal_year_month[i] >= 7
                   yearly_data["#{year_range[y]-1}-"+month_text[fiscal_year_month[i].to_i-1]+"-01"] = fiscal_year_people[i]
                 else
                   yearly_data["#{year_range[y]}-"+month_text[fiscal_year_month[i].to_i-1]+"-01"] = fiscal_year_people[i]
                 end
               end
             end  
             
         end

         if time_frame=="All"
            return all_data
         elsif time_frame=="Yearly"  
            return yearly_data
         end
      end

      #Need to get each bin for the frequency data:
      if count_type=="Frequency"
         freq_info=[]

         people=copy_table.pluck("card_num").uniq
         num_users=people.count

         enroll_names=['SAS','Wharton','Annenberg','Dental','Weitzman','Education','Engineering','Law','Perelman','Veterinary',
                       'Nursing','SP2']
         #For right now this is hardcoded for the most recent year.
         total_pop=enrollment_table("Total")[-1][enroll_names[school_index]]

         puts "Library Users number #{num_users}"
         puts "Enrollment total is #{total_pop}"

         week_range=(time.min.to_i..time.max.to_i).to_a
         week_index=(0..week_range.length-1).to_a
         
         percents_zero=Hash.new
         percents_single=Hash.new
         percents_medium=Hash.new
         percents_freq=Hash.new
         
         for i in week_index
            week_data=copy_table.select{|h| h["week"] == week_range[i]}
            card_num=week_data.pluck('card_num')

            test_array=card_num.uniq
            
            single_user=0
            medium_user=0
            freq_user=0
          
            for x in test_array
                 if card_num.count(x)==1
                    single_user=single_user+1
                 elsif card_num.count(x) == 2 || card_num.count(x) == 3
                    medium_user=medium_user+1
                 elsif card_num.count(x) > 3
                    freq_user=freq_user+1
                 end
            end  

            #Need to remember to return as a percentage of the college population
            
            ymax=(num_users).fdiv(total_pop)
            ymax=(ymax.round(2))*100
            
            percents_zero["#{week_range[i]}"]=(num_users-single_user-medium_user-freq_user).fdiv(total_pop)
            percents_single["#{week_range[i]}"]=((single_user).fdiv(total_pop))*100
            percents_medium["#{week_range[i]}"]=((medium_user).fdiv(total_pop))*100
            percents_freq["#{week_range[i]}"]=((freq_user).fdiv(total_pop))*100

         end
         return ymax,percents_single,percents_medium,percents_freq
      end

      return count_array
            
  end

  def percent_change(input_data)
  #Might be able to add to calc_percents function...

     data_length=input_data.length

     all_data=[]
  
     for l in (0..input_data.length-1).to_a
         months=["January","February","March","April","May","June","July","August","September","October","November","December","Total"]
         month_data=Hash.new
         
         for m in (0..months.length-1).to_a
               #Reading in an array of hashes, comparing each year's month data to the comparison_year (most recent), then output an array of hashes of the differences.
             old_data=input_data[l][months[m]]
             new_data=input_data[data_length-1][months[m]]
             if old_data.nil? == true || l==input_data.length-1
                percent_change=nil
             else  
                percent_change=(old_data-new_data).fdiv(new_data)
                percent_change=percent_change*100
                percent_change=percent_change.round(2)
             end
             month_data[months[m]]=percent_change
         end
         month_data["Statistics"]="% Change"
         all_data << month_data
         
      end
      return all_data
  end
end

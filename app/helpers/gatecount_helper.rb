module GatecountHelper

#Library options are "Van Pelt", "Biotech", "Furness", "All"
  
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
              AND school IN ('College of Arts & Sciences','The Wharton School','Annenberg School for Communication','School of Dental Medicine','School of Design','Graduate School of Education','School of Engineering and Applied Science','Law School','Perelman School of Medicine','Veterinary Medicine','School of Nursing','Social Policy & Practice','School of Social Policy & Practice')
              GROUP BY 1, 2, 3, 4
              ORDER BY COUNT(swipe_date);")

      return output_table.to_a
  end

  #Excluding Penn libraries so that workers who swipe in all the time are not counted.
  
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
           AND school != 'Penn Libraries' 
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

    #year_values=pop_table.to_a.select{|h| h["fiscal_year"]==2023}
    year_values=pop_table.to_a
        
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
        elsif user=="Graduate"
           values=year_values.select{|h| h["school"]==enroll_names[i]}.pluck("value")[4]
        elsif user=="F/S"
           values=year_values.select{|h| h["school"]==enroll_names[i]}.pluck("value")[10]
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
    #1) "Counts" is the percentage of counts relative to the total (user) population.
    #2) "People" is the percentage of people relative to the total (user) population.
    #3) "Raw Counts" is just the number of counts, no percentages.
    #4) "Individuals" is the number of people, no percentages.
    
    if user_group == "Grad Student" || user_group == "Undergraduate Student"
      copy_table=input_table.select{|h| h["user_group"] == user_group}
      copy_table=copy_table.delete_if{|h| h["school"] == "Social Policy & Practice"}
    elsif user_group == "F/S"
      copy_table=input_table.select{|h| (h["user_group"].include? "Staff") || (h["user_group"].include? "Faculty")}
    else
      copy_table=input_table
    end
    
    if type=="Counts"
     num_swipes=copy_table.pluck("num_swipes")
     percents=num_swipes.map {|x| ((x).fdiv(num_swipes.sum))*100}
    elsif type=="People"  
      num_people=copy_table.pluck("num_people")
      percents=num_people.map {|x| ((x).fdiv(num_people.sum))*100}
    elsif type=="Raw Counts"
      percents=copy_table.pluck("num_swipes")
    elsif type=="Individuals"
      percents=copy_table.pluck("num_people")
    end

     schools=['College of Arts & Sciences',"The Wharton School","Annenberg School for Communication","School of Dental Medicine","School of Design",'Graduate School of Education','School of Engineering and Applied Science','Law School',"Perelman School of Medicine","Veterinary Medicine","School of Nursing",'Social Policy & Practice']

    if user_group != "F/S"
        schools=copy_table.pluck("school")
        percents_array=Hash.new
        percent_index=(0..percents.length-1).to_a
        percent_index.each {|i| percents_array[schools[i]] = percents[i]}
    #Necessary clause since the "Faculty and Staff" category includes multiple user groups.
    elsif user_group=="F/S"

        percents_array=Hash.new

        all_counts=copy_table.pluck("num_swipes").sum
        
        for s in schools
            school_table=copy_table.select{|h| h["school"] == s}
            if type=="Counts"
               percents=((school_table.pluck("num_swipes").sum).fdiv(all_counts))*100
            else
               percents=(school_table.pluck("num_people").sum)
            end  
            percents_array[s] = percents
        end
        
    end
    return percents_array
    
  end

  def time_counts(input_table,time_frame,count_type,school_index=0)
    
      copy_table=input_table

      month_names=["January","February","March","April","May","June","July","August","September","October","November","December"]
      month_text=["01","02","03","04","05","06","07","08","09","10","11","12"]
      
      if time_frame=="Monthly"
         time=copy_table.pluck("month")

         if count_type=="Counts"
            count=copy_table.pluck("num_swipes")
         elsif count_type=="People"
            count=copy_table.pluck("num_people")
         end
         
         temp_array=Hash.new
         count_array=Hash.new

         temp_index=[6,7,8,9,10,11,0,1,2,3,4,5]
         count_index=(0..count.length-1).to_a

         count_index.each {|i| temp_array[month_names[time[i].to_i-1]] = count[i]}
         temp_index.each {|i| count_array[month_names[i]]=temp_array[month_names[i]]}

         return count_array
         
      else 
         time=copy_table.pluck("fiscal_year")
         all_data=[]
        
         years=time
         year_range=[2016,2017,2018,2019,2020,2021,2022,2023]
         year_index=[0,1,2,3,4,5,6,7]

         yearly_data=Hash.new

         for y in year_index
             fiscal_year_data=copy_table.select{|h| h["fiscal_year"] == year_range[y]}
             month=fiscal_year_data.pluck('month')
             year_counts=fiscal_year_data.pluck('num_swipes')
             year_people=fiscal_year_data.pluck('num_people')

             if count_type=="Counts" && time_frame=='Fiscal_Year'
                yearly_data["#{year_range[y]}"] = year_counts
             elsif count_type=="People" && time_frame=='Fiscal_Year'
                yearly_data["#{year_range[y]}"] = year_people
             end
             
             fiscal_array=Hash.new
             fiscal_index=(0..year_counts.length-1).to_a
             if time_frame=="Yearly" && count_type=="Counts"
               #Here needs to actually be in the correct time order.
               for i in fiscal_index
                   if month[i] >= 7
                     if count_type=="Counts"
                        yearly_data["#{year_range[y]-1}-"+month_text[month[i].to_i-1]+"-01"] = year_counts[i]
                     else
                        yearly_data["#{year_range[y]-1}-"+month_text[month[i].to_i-1]+"-01"] = year_people[i]
                     end  
                   else
                     if count_type=="Counts"  
                        yearly_data["#{year_range[y]}-"+month_text[month[i].to_i-1]+"-01"] = year_counts[i]
                     else
                        yearly_data["#{year_range[y]}-"+month_text[month[i].to_i-1]+"-01"] = year_people[i]
                     end
                   end  
               end
               
             elsif time_frame=="All"
                fiscal_index.each {|i| fiscal_array[month_names[month[i].to_i-1]] = year_counts[i]}
                fiscal_array["Total"]=year_counts.sum
                fiscal_array["Statistics"]="Count"
                all_data << fiscal_array
             end
         end

         if time_frame=="All"
            return all_data
         else
            return yearly_data
         end
      end
  end

  def freq_counts(input_table,fiscal_year,school_index)
      copy_table=input_table
      time=copy_table.pluck("week")
      
      #Don't know why this is not working...
      #fiscal_years=copy_table.pluck("fiscal_year")
      #fiscal_year_max=(fiscal_years).max
      
      enroll_names=['SAS','Wharton','Annenberg','Dental','Weitzman','Education','Engineering','Law','Perelman','Veterinary','Nursing','SP2']
      
      total_pop=enrollment_table("Total")[fiscal_year-2024][enroll_names[school_index]]

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

          #Return as a percentage of the college population            
          ymax=(num_users).fdiv(total_pop)
          ymax=(ymax.round(2))*100
            
          percents_zero["#{week_range[i]}"]=(num_users-single_user-medium_user-freq_user).fdiv(total_pop)
          percents_single["#{week_range[i]}"]=((single_user).fdiv(total_pop))*100
          percents_medium["#{week_range[i]}"]=((medium_user).fdiv(total_pop))*100
          percents_freq["#{week_range[i]}"]=((freq_user).fdiv(total_pop))*100

      end
      
      return ymax,percents_single,percents_medium,percents_freq
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

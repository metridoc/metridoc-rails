module GatecountHelper

  #Define arrays and hashes that are consistently used:
  #Note: need to add "Social Policy & Practice" for the first SQL query below because for some reason that
  #is the correct name for the school when querying for Faculty and Staff.
  def gc_schools
    ["College of Arts & Sciences","The Wharton School","Annenberg School for Communication",
"School of Dental Medicine","School of Design","Graduate School of Education",
"School of Engineering and Applied Science","Law School","Perelman School of Medicine",
"Veterinary Medicine","School of Nursing","School of Social Policy & Practice"]
  end

  #The names of the schools are different in the enrollments table.
  def gc_enroll_names
      ['SAS','Wharton','Annenberg','Dental','Weitzman','Education','Engineering','Law','Perelman','Veterinary','Nursing','SP2']
  end  

  def gc_doors
    ['VAN PELT LIBRARY ADA DOOR_ *VPL', 'VAN PELT LIBRARY TURN1_ *VPL','VAN PELT LIBRARY TURN2_ *VPL','VAN PELT LIBRARY USC HANDICAP ENT VERIFY_ *VPL','FURNESS TURNSTILE_ *FUR', 'BIO LIBRARY TURNSTILE GATE_ *JSN']
  end

  def gc_users
    {"Total" => "Enrollment Total","Undergrad" => "Undergraduate Total","Graduate" => "Graduate Total","F/S" => "Regular Faculty & Staff Total"}
  end

  def gc_months
    Date::MONTHNAMES.compact
  end

  #Inputting these values manually since they're not in Metridoc.
  def gc_all_bio
      bio_2016=["Count",10490,8165,11270,11178,10144,6803,4951,10103,7852,9605,8142,7416,106119]
      bio_2017=["Count",7374,7350,9660,10571,9037,8079,7033,9109,8644,9599,8363,8021,102840]
      bio_2018=["Count",6461,7310,9902,10568,8869,7296,6995,7658,8178,9813,7434,7012,97496]
      bio_2019=["Count",7374,6845,9503,11208,9407,8719,6486,9469,9581,11740,8010,8689,107031]
      bio_2020=["Count",9271,8631,12122,13036,9764,9624,7683,11430,4295,nil,nil,nil,85856]
      bio_2021=["Count"].concat(Array.new(13))
      full_bio=[bio_2016,bio_2017,bio_2018,bio_2019,bio_2020,bio_2021]
      return full_bio
  end
  
#Define tables that are frequently used:
  
#Library options are "Van Pelt", "Biotech", "Furness", "All"

  #The library_table is used for all "population" plots (grouped by school).
  def gc_library_table
      doors=gc_doors.map{|e| "'#{e}'"}.join(",")
      schools=gc_schools.map{|e| "'#{e}'"}.join(",")
      
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
           WHERE door_name IN (#{doors})
              AND school IN (#{schools}, 'Social Policy & Practice')
              GROUP BY 1, 2, 3, 4
              ORDER BY COUNT(swipe_date);")

      return output_table.to_a
  end

  #The time_table is used for all time plots *except* for the frequency plots by school.
  #Excluding "Penn libraries" here so that workers who swipe in all the time are not counted.
  def gc_time_table
      doors=gc_doors.map{|e| "'#{e}'"}.join(",")
      
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
           WHERE door_name IN (#{doors})
           AND school != 'Penn Libraries' 
         GROUP BY 1,2,3;")

      return output_table.to_a
  end

  #Used for the plot on the _index page and the _population page
  def gc_freq_table(semester,input_year,input_school)

      doors=gc_doors.map{|e| "'#{e}'"}.join(",")
    
      if semester=="Spring"
         start_week=1
         end_week=20
      elsif semester=="Summer"
         start_week=22
         end_week=33
      elsif semester=="Fall"
         start_week=34
         end_week=53
      end
      
      output_table=GateCount::CardSwipe.connection.select_all(
        "WITH weekly_data AS (
         SELECT
           EXTRACT(week from swipe_date) AS week,
           card_num,
           COUNT(*) AS frequency,
           CASE
                WHEN door_name LIKE 'VAN PELT%'
                  THEN 'Van Pelt'
                WHEN door_name LIKE 'FURNESS%'
                  THEN 'Furness'
                WHEN door_name LIKE 'BIO%'
                  THEN 'Biotech'
           END AS library
         FROM gate_count_card_swipes 
              WHERE (EXTRACT(week from swipe_date) >= #{start_week} AND EXTRACT(week from swipe_date) <= #{end_week})
              AND school='#{input_school}'
              AND DATE_PART('year', swipe_date + INTERVAL '6 month')=#{input_year}
              AND (user_group='Undergraduate Student' OR user_group='Grad Student')
              AND door_name IN (#{doors})
           GROUP BY 1, 2, 4)
          SELECT
              week,
              card_num,
              library,
              CASE WHEN frequency = 1 THEN 1 ELSE 0 END AS single_user,
              CASE WHEN frequency BETWEEN 2 AND 3 THEN 1 ELSE 0 END AS medium_user,
              CASE WHEN frequency > 3 THEN 1 ELSE 0 END AS freq_user
              FROM weekly_data;")

      return output_table.to_a
  end

  def gc_enrollment_table(user,input_year=2023)
    pop_table=Upenn::Enrollment.select(:fiscal_year, :user, :value, :school).where(:user => gc_users[user]).where(:school_parent => "Total").where(:fiscal_year => input_year).where.not(:school => "Non-Academic").all

    yearly_enroll=Hash.new
    
    for name in gc_enroll_names
        values=pop_table.to_a.select{|h| h["school"]==name}.pluck("value")[0]
        yearly_enroll[name] = values
    end
    
    return yearly_enroll
    
  end

#Define helper functions:
  
  #Delete data from the wrong year/library/school:
  def gc_gen_stats(input_table,fiscal_year,library,school_type)
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

  def gc_calc_percents(input_table,type,user_group)
    
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
    #Otherwise leave the table unchanged.
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

    #"School of Social Policy & Practice" is called something different for F/S:
    schools=gc_schools[0..10].concat(['Social Policy & Practice'])

    if user_group != "F/S"
        schools=copy_table.pluck("school")
        percents_array=Hash.new
        percents.each_with_index {|p,i| percents_array[schools[i]] = p}
    #Needed since the "Faculty and Staff" category includes multiple user groups and therefore
    #multiple entries per school.
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

  #Put the data in the desired time and count bins. Current options for time_frame are:
  #"Monthly", "Fiscal_Year", "Yearly" (calendar year), and "All" (all data available in Metridoc).
  #This function is used for the plots generated in "_overview.html.haml"
  def gc_time_counts(input_table,time_frame,count_type)
    
      copy_table=input_table

      month_text=["01","02","03","04","05","06","07","08","09","10","11","12"]
      
      if time_frame=="Monthly"
         time=copy_table.pluck("month")

         if count_type=="Counts"
            count=copy_table.pluck("num_swipes")
         elsif count_type=="People"
            count=copy_table.pluck("num_people")
         end

         #First save the data in month order, then rearrange to the fiscal year.
         temp_array=Hash.new
         count_array=Hash.new

         temp_index=(0..count.length-1).to_a
         count_index=[6,7,8,9,10,11,0,1,2,3,4,5]

         temp_index.each {|i| temp_array[gc_months[time[i].to_i-1]] = count[i]}
         count_index.each {|i| count_array[gc_months[i]]=temp_array[gc_months[i]]}
         
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
             month.each{|m| m.to_i}
             
             year_counts=fiscal_year_data.pluck('num_swipes')
             year_people=fiscal_year_data.pluck('num_people')

             if count_type=="Counts" && time_frame=='Fiscal_Year'
                yearly_data["#{year_range[y]}"] = year_counts.sum
             elsif count_type=="People" && time_frame=='Fiscal_Year'
                yearly_data["#{year_range[y]}"] = year_people.sum
             end
             
             fiscal_array=Hash.new
             fiscal_index=(0..year_counts.length-1).to_a
             if time_frame=="Yearly"
               #Here the desired output is in calendar years.
               for i in fiscal_index
                   if month[i] >= 7
                     if count_type=="Counts"
                        yearly_data["#{year_range[y]-1}-"+month_text[month[i]-1]+"-01"] = year_counts[i]
                     elsif count_type=="People"
                        yearly_data["#{year_range[y]-1}-"+month_text[month[i]-1]+"-01"] = year_people[i]
                     end  
                   else
                     if count_type=="Counts"  
                        yearly_data["#{year_range[y]}-"+month_text[month[i]-1]+"-01"] = year_counts[i]
                     elsif count_type=="People"
                        yearly_data["#{year_range[y]}-"+month_text[month[i]-1]+"-01"] = year_people[i]
                     end
                   end  
               end

             #This is intended for table output. 
             elsif time_frame=="All"
                fiscal_index.each {|i| fiscal_array[gc_months[month[i]-1]] = year_counts[i]}
                fiscal_array["Total"]=year_counts.sum
                fiscal_array["Statistics"]="Count"
                all_data << fiscal_array
             end
         end
      end

      #Make sure the correct output is generated.
      if time_frame=="All"
         return all_data
      elsif time_frame=="Yearly" || time_frame=="Fiscal_Year"
         return yearly_data
      elsif time_frame=="Monthly"
         return count_array
      end
      
  end

  #Makes the plot shown on the _index page and the _population page.
  def gc_freq_counts(input_table,fiscal_year,school_index,library)
      copy_table=input_table

      #Select the library of interest:
      if library=="Biotech"
       copy_table=copy_table.select{|h| h["library"] == "Biotech"}
      elsif library=="Furness"
       copy_table=copy_table.select{|h| h["library"] == "Furness"}
      elsif library=="Van Pelt"
       copy_table=copy_table.select{|h| h["library"] == "Van Pelt"}        
      end

      time=copy_table.pluck("week")
      card_num=copy_table.pluck('card_num')
      
      num_users=card_num.uniq.length
      
      total_pop=gc_enrollment_table("Total",fiscal_year)[gc_enroll_names[school_index.to_i]]

      week_range=(time.min.to_i..time.max.to_i).to_a
      week_index=(0..week_range.length-1).to_a

      #One for each bin of user frequency:
      percents_zero=Hash.new
      percents_single=Hash.new
      percents_medium=Hash.new
      percents_freq=Hash.new
      
      for i in week_index

          week_table=copy_table.select{|h| h["week"] == week_range[i]}
          
          single_user=week_table.pluck('single_user').sum
          medium_user=week_table.pluck('medium_user').sum
          freq_user=week_table.pluck('freq_user').sum

          #Return as a percentage of the college population
          ymax=(num_users).fdiv(total_pop)
          ymax=(ymax.round(2))*100

          if week_range.min < 21
             percents_zero["#{week_range[i]}"]=(num_users-single_user-medium_user-freq_user).fdiv(total_pop)
             percents_single["#{week_range[i]}"]=((single_user).fdiv(total_pop))*100
             percents_medium["#{week_range[i]}"]=((medium_user).fdiv(total_pop))*100
             percents_freq["#{week_range[i]}"]=((freq_user).fdiv(total_pop))*100
          #Get the correct labels for the summer semester:
          elsif week_range.min >= 22 and week_range.min <= 33
             percents_zero["#{week_range[i]-21}"]=(num_users-single_user-medium_user-freq_user).fdiv(total_pop)
             percents_single["#{week_range[i]-21}"]=((single_user).fdiv(total_pop))*100
             percents_medium["#{week_range[i]-21}"]=((medium_user).fdiv(total_pop))*100
             percents_freq["#{week_range[i]-21}"]=((freq_user).fdiv(total_pop))*100
          #Get the correct labels for the fall semester:
          elsif week_range.min >=34 
             percents_zero["#{week_range[i]-33}"]=(num_users-single_user-medium_user-freq_user).fdiv(total_pop)
             percents_single["#{week_range[i]-33}"]=((single_user).fdiv(total_pop))*100
             percents_medium["#{week_range[i]-33}"]=((medium_user).fdiv(total_pop))*100
             percents_freq["#{week_range[i]-33}"]=((freq_user).fdiv(total_pop))*100
          end
      end
      return ymax,percents_single,percents_medium,percents_freq
  end
      
  #Reads in an array of hashes, comparing each year's month data to the comparison_year
  #(by default the most recent), then outputs an array of hashes of the differences.
  def gc_percent_change(input_data)

     data_length=input_data.length

     months=gc_months.concat(["Total"])
     all_data=[]
  
     for l in (0..input_data.length-1).to_a
         month_data=Hash.new         
         for m in (0..months.length-1).to_a
             old_data=input_data[l][months[m]]
             new_data=input_data[data_length-1][months[m]]
             if old_data.nil? == true || l==input_data.length-1
                percent_change=nil
             elsif new_data.nil? == true || l==input_data.length-1
                percent_change=nil 
             else  
                percent_change=(old_data-new_data).fdiv(new_data)
                percent_change=(percent_change*100).round(2)
             end
             month_data[months[m]]=percent_change
         end
         month_data["Statistics"]="% Change"
         all_data << month_data
         
      end
      return all_data
  end
end

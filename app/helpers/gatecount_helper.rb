module GatecountHelper

#Library options are "Van Pelt", "Biotech", "Furness", "All"
#Student type= "Grad Student" or "Undergraduate Student"
  
  def library_table(library,fiscal_year,student_type)
    if library="Furness"
      output_table=GateCount::CardSwipe.find_by_sql(
        "SELECT COUNT(DISTINCT card_num), COUNT (card_num) FROM gate_count_card_swipes
               WHERE door_name='FURNESS TURNSTILE_ *FUR'
               AND user_group='#{student_type}'
               AND swipe_date BETWEEN '#{fiscal_year-1}-07-01'
               AND '#{fiscal_year}-06-30'
               GROUP BY school;")
    elsif library="Biotech"
      output_table=GateCount::CardSwipe.find_by_sql(
          "SELECT COUNT(DISTINCT card_num), COUNT (card_num) FROM gate_count_card_swipes
               WHERE door_name='BIO LIBRARY TURNSTILE GATE_*JSN'
               AND user_group='#{student_type}'
               AND swipe_date BETWEEN '#{fiscal_year-1}-07-01'
               AND '#{fiscal_year}-06-30'
               GROUP BY school;")
    elsif library="Van Pelt"
      output_table=GateCount::CardSwipe.find_by_sql(
          "SELECT COUNT(DISTINCT card_num), COUNT (card_num) FROM  gate_count_card_swipes
               WHERE (door_name='VAN PELT LIBRARY TURN1_ *VPL'
               OR door_name='VAN PELT LIBRARY TURN2_ *VPL'
               OR door_name='VAN PELT LIBRARY USC HANDICAP ENT VERIFY_ *VPL'
               OR door_name='VAN PELT LIBRARY ADA DOOR_ *VPL')
               AND user_group='#{student_type}'
               AND swipe_date BETWEEN '#{fiscal_year-1}-07-01'
               AND '#{fiscal_year}-06-30'
               GROUP BY school;") 
    else
      output_table=GateCount::CardSwipe.find_by_sql(
          "SELECT COUNT(DISTINCT card_num), COUNT (card_num)  FROM  gate_count_card_swipes
               WHERE (door_name='VAN PELT LIBRARY TURN1_ *VPL'
               OR door_name='VAN PELT LIBRARY TURN2_ *VPL'
               OR door_name='VAN PELT LIBRARY USC HANDICAP ENT VERIFY_ *VPL'
               OR door_name='VAN PELT LIBRARY ADA DOOR_ *VPL'
               OR door_name='FURNESS TURNSTILE_ *FUR'
               OR door_name='BIO LIBRARY TURNSTILE GATE_*JSN')
               AND user_group='#{student_type}'
               AND swipe_date BETWEEN '#{fiscal_year-1}-07-01'
               AND '#{fiscal_year}-06-30'
               GROUP BY school;")
      
    #Will need to put options for:
    #1) Gate counts per school

    end

    #Get the full gate counts:
    all_counts=0
    
    #output_table.each do |row|
      #row[]

    puts output_table.to_a
    
    return output_table, all_counts

  end

end  

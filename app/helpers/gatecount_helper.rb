module GatecountHelper

  def library_table(library,fiscal_year)
    if library="Furness"
      output_table=GateCount::CardSwipe.connection.select_all(
          "SELECT * FROM gate_count_card_swipes
               WHERE door_name='FURNESS TURNSTILE_ *FUR'
               AND swipe_date BETWEEN '#{fiscal_year-1}-07-01'
               AND '#{fiscal_year}-06-30';")
    elsif library="Biotech"
      output_table=GateCount::CardSwipe.connection.select_all(
          "SELECT * FROM gate_count_card_swipes
               WHERE door_name='BIO LIBRARY TURNSTILE GATE_*JSN' AND swipe_date                BETWEEN '#{fiscal_year-1}-07-01' AND '#{fiscal_year}-06-30';")
    else
      output_table=GateCount::CardSwipe.connection.select_all(
          "SELECT * FROM  gate_count_card_swipes
               WHERE (door_name='VAN PELT LIBRARY TURN1_ *VPL' door_name='VAN PE                LT LIBRARY TURN2_ *VPL' OR door_name='VAN PELT LIBRARY USC HANDI                CAP ENT VERIFY_ *VPL' OR door_name='VAN PELT LIBRARY ADA DOOR_ *                VPL') AND swipe_date BETWEEN '#{fiscal_year-1}-07-01' AND '#{fisc                al_year}-06-30';")    

    #Will need to put options for:
    #1) Library
    #2) Financial Year
    #3) School
    #4)Gate counts Total or Percentage total

    end
    
    return output_table

  end

end  

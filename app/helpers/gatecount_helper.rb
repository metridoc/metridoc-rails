module GatecountHelper

  def library_table(library,fiscal_year)
    if library="Furness"
      GateCount::CardSwipe.connection.select_all(
          "SELECT
               WHERE door_name='FURNESS TURNSTILE_ *FUR'
               AND swipe_date BETWEEN '#{fiscal_year-1}-07-01'
               AND #{fiscal_year}-06-30';").rows
    elsif library="Biotech"
      GateCount::CardSwipe.connection.select_all(
          "SELECT
               WHERE door_name='BIO LIBRARY TURNSTILE GATE_*JSN' AND swipe_date                BETWEEN '#{fiscal_year-1}-07-01' AND #{fiscal_year}-06-30';").rows
    else
      GateCount::CardSwipe.connection.select_all(
          "SELECT
               WHERE (door_name='VAN PELT LIBRARY TURN1_ *VPL' door_name='VAN PE                LT LIBRARY TURN2_ *VPL' OR door_name='VAN PELT LIBRARY USC HANDI                CAP ENT VERIFY_ *VPL' OR door_name='VAN PELT LIBRARY ADA DOOR_ *                VPL') AND swipe_date BETWEEN '#{fiscal_year-1}-07-01' AND #{fisc                al_year}-06-30';").rows      
    
    #Will need to put options for:
    #1) Library
    #2) Financial Year
    #3) School

    end
    
  end

end  

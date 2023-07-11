module GatecountHelper

  def library_table(library,fiscal_year)
    if library="Furness"
        model::GateCounts::CardSwipe.connection.select_all(
          "SELECT
               WHERE GateCountsCardSwipe.door_name='FURNESS TURNSTILE_ *FUR'
               AND GateCountsCardSwipe.swipe_date BETWEEN '#{fiscal_year-1}-07-0               1' AND #{fiscal_year}-06-30';").rows
    elsif library="Biotech"
         model::GateCounts::CardSwipe.connection.select_all(
          "SELECT
               WHERE GateCountsCardSwipe.door_name='BIO LIBRARY TURNSTILE GATE_                 *JSN' AND GateCountsCardSwipe.swipe_date BETWEEN '#{fiscal_year-                1}-07-01' AND #{fiscal_year}-06-30';").rows
    else
         model::GateCounts::CardSwipe.connection.select_all(
          "SELECT
               WHERE (GateCountsCardSwipe.door_name='VAN PELT LIBRARY TURN1_ *VP                L' OR GateCountsCardSwipe.door_name='VAN PELT LIBRARY TURN2_ *VP                L' OR GateCountsCardSwipe.door_name='VAN PELT LIBRARY USC HANDIC                AP ENT VERIFY_ *VPL' OR GateCountsCardSwipe.door_name='VAN PELT                 LIBRARY ADA DOOR_ *VPL') AND GateCountsCardSwipe.swipe_date BETW                EEN '#{fiscal_year-1}-07-01' AND #{fiscal_year}-06-30';").rows      
    
    #Will need to put options for:
    #1) Library
    #2) Financial Year
    #3) School

end

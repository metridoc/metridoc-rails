class Borrowdirect::Bibliography < Borrowdirect::Base


  ransacker :request_number do
    Arel.sql("COALESCE (request_number,'')")
  end

end

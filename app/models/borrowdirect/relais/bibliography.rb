class Borrowdirect::Bibliography < Borrowdirect::Base

  ransacker :borrower do
    Arel.sql("to_char(borrower, '9999999999')")
  end

  ransacker :lender do
    Arel.sql("to_char(lender, '9999999999')")
  end

  ransacker :oclc do
    Arel.sql("to_char(oclc, '9999999999999999999')")
  end

  ransacker :request_number do
    Arel.sql("COALESCE (request_number,'')")
  end

end

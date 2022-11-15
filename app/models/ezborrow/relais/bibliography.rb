class Ezborrow::Relais::Bibliography < Ezborrow::Relais::Base

  ransacker :borrower do
    Arel.sql("to_char(borrower, '9999999999')")
  end

  ransacker :lender do
    Arel.sql("to_char(lender, '9999999999')")
  end

  ransacker :oclc do
    Arel.sql("to_char(oclc, '9999999999999999999')")
  end

end

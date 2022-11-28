class Borrowdirect::Relais::CallNumber < Borrowdirect::Relais::Base

  ransacker :holdings_seq do
    Arel.sql("to_char(holdings_seq, '9999999999')")
  end

end

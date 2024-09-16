class Borrowdirect::Reshare::PatronRequest < Borrowdirect::Reshare::Base

  self.ignored_columns = [
    :pr_patron_identifier
  ]
  
end

class Ezborrow::Reshare::PatronRequest < Ezborrow::Reshare::Base

  self.ignored_columns = [
    :pr_patron_identifier
  ]

end

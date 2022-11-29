class GateCount::CardSwipe < GateCount::Base
  self.ignored_columns = [
    :first_name, :last_name, :card_num, :pennkey
  ]
end

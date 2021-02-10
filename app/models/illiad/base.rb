class Illiad::Base < ApplicationRecord
  belongs_to :institution

  self.abstract_class = true
  self.table_name_prefix = 'illiad_'

  ransacker :group_no do
    Arel.sql("to_char(group_no, '9999999999')")
  end

  ransacker :transaction_number do
    Arel.sql("to_char(transaction_number, '9999999999')")
  end
end

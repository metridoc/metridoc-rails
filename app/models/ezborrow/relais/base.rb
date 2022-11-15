class Ezborrow::Relais::Base < ApplicationRecord
  self.abstract_class = true
  self.table_name_prefix = 'ezborrow_'

  ransacker :library_id do
    Arel.sql("to_char(library_id, '9999999999')")
  end
end

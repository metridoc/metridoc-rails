module Marc

  class BookMod < ActiveRecord::Base
    self.table_name_prefix = 'marc_'

  end

end

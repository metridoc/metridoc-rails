class Alma::Circulation < Alma::Base
  self.ignored_columns = [:first_name, :last_name, :penn_id_number, :preferred_email]
  self.reset_column_information
end

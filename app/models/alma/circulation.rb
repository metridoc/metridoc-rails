class Alma::Circulation < Alma::Base
  self.ignored_columns = [
    :first_name,
    :last_name,
    :user_id,
    :penn_id_number,
    :preferred_email
  ]
end

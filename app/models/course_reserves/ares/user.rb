class CourseReserves::Ares::User < CourseReserves::Ares::Base
  self.ignored_columns = [
    :username, :last_name, :first_name, :library_id,
    :e_mail_address, :external_user_id
  ]
end

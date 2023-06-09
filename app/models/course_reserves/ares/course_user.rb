class CourseReserves::Ares::CourseUser < CourseReserves::Ares::Base
  self.ignored_columns = [
    :username
  ]
end

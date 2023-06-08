class CourseReserves::Ares::ItemTracking < CourseReserves::Ares::Base
  self.ignored_columns = [
    :username
  ]
end

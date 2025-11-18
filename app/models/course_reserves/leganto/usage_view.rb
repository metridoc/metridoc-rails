class CourseReserves::Leganto::UsageView < CourseReserves::Leganto::Base
  #belongs_to :searchable, polymorphic: true

  self.primary_key = :id 

  def readonly?
    true
  end
end
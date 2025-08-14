class Springshare::Libwizard::CandiView < ApplicationRecord
  #belongs_to :searchable, polymorphic: true

  self.primary_key = :id 

  def readonly?
    true
  end
end

class Security::UserRoleAccessDefinition < ApplicationRecord
  belongs_to :user_role

  scope :of_element_access_level, -> (element, access_level) { where(element: element, access_level: access_level) }

end

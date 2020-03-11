class Security::UserRoleAccessDefinition < ApplicationRecord
  belongs_to :user_role

  scope :of_element_access_level, -> (element, access_level) { where(element: element, access_level: access_level) }

  def element_name
    Object.const_defined?(element) && !element.constantize.is_a?(Module) ? element.constantize.model_name.human(count: 2) : I18n.t("phrases.user_role_elements.#{element.downcase}")
  end

end

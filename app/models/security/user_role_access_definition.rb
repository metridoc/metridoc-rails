class Security::UserRoleAccessDefinition < ApplicationRecord
  belongs_to :user_role

  validates :access_level, presence: true
  validates :element, presence: true
  validates :element, uniqueness: { scope: :user_role_id }, if: proc { |a| a.element.present? }

  scope :of_element_access_level, -> (element, access_level) { where(element: element, access_level: access_level) }

  def element_name
    Security::UserRoleAccessDefinition.element_humanized_name(element)
  end

  def self.element_humanized_name(element)
    Object.const_defined?(element) && element.constantize.is_a?(Class) ? element.constantize.model_name.human(count: 2) : I18n.t("phrases.user_role_elements.#{element.downcase}")
  rescue
    "???"
  end

end

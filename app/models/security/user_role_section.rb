class Security::UserRoleSection < ApplicationRecord
  belongs_to :user_role

  validates :access_level, presence: true
  validates :section, presence: true
  validates :section, uniqueness: { scope: :user_role_id }, if: proc { |a| a.section.present? }

  scope :of_section_access_level, -> (section, access_level) {
    where("lower(section) = ?", section.downcase).where(access_level: access_level)
  }

  def section_name
    Security::UserRoleSection.section_humanized_name(section)
  end

  def self.section_humanized_name(section)
    Object.const_defined?(section) && section.constantize.is_a?(Class) ? section.constantize.model_name.human(count: 2) : I18n.t("phrases.user_role_sections.#{section.downcase}")
  rescue
    "???"
  end

end

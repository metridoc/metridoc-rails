class Security::UserRole < ApplicationRecord
  has_many :admin_users
  has_many :user_role_access_definitions, class_name: "Security::UserRoleAccessDefinition"

  accepts_nested_attributes_for :user_role_access_definitions, allow_destroy: true

  MANAGED_ELEMENTS = [AdminUser, Security::UserRole, DataSource::Template, DataSource::Source]
  ACCESS_LEVELS = ["read-only", "edit"]

  def authorized?(action, subject)
    s = subject.is_a?(Class) ? subject : subject.class

    s = DataSource::Template if s == DataSource::TemplateStep
    s = DataSource::Source if s == DataSource::SourceStep

    return true unless s.in?(MANAGED_ELEMENTS)

    if action == :read
      access_level = ['read-only', 'edit']
    else
      access_level = 'edit'
    end

    puts "checking: #{s.to_s} - #{access_level} - #{action.to_s}"

    return self.user_role_access_definitions.of_element_access_level(s.to_s, access_level).present?
  end

end

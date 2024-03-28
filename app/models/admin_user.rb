class AdminUser < ApplicationRecord
  belongs_to :user_role, class_name: "Security::UserRole", optional: true
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :trackable,
         :recoverable, :rememberable, :validatable

  def to_xml(options = {})
    xml = options[:builder] ||= ::Builder::XmlMarkup.new(indent: options[:indent])
    xml.admin_user do
      xml.tag!(:id, id)
      xml.tag!(:email, email)
      xml.tag!(:created_at, created_at)
      xml.tag!(:updated_at, updated_at)
    end
  end

  def authorized?(action, subject)
    return true if self.super_admin?

    # check for edit_profile
    return true if subject == self

    return !Security::UserRole.subject_secured?(subject) if self.user_role.blank?

    return self.user_role.authorized?(action, subject)
  end

  def full_name
    self.first_name.blank? && self.last_name.blank? ? "#{self.email}" : [self.first_name, self.last_name].join(" ")
  end

  def can_edit_system_admin_attribute?(admin_user)
    return system_admin? && admin_user != self
  end

  # Don't keep the IP addresses of logins
  def current_sign_in_ip; end
  def last_sign_in_ip=(_ip); end
  def current_sign_in_ip=(_ip); end

  protected
  def password_required?
    self.encrypted_password.blank?
  end

end

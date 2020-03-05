class AdminUser < ApplicationRecord
  belongs_to :user_role, class_name: "Security::UserRole"
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, 
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
    return self.user_role.blank? ? false : self.user_role.authorized?(action, subject)
  end

  protected 
  def password_required? 
    self.encrypted_password.blank?
  end 

end

class AdminUser < ApplicationRecord
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

end

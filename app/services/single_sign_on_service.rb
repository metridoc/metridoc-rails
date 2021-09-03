class SingleSignOnService
  
  def initialize(request)
    self.request = request
  end

  def get_or_create_user
    Rails.logger.info("SingleSignOnService.get_or_create_user emai: [#{email}]")
    Rails.logger.info("SingleSignOnService.get_or_create_user first_name: [#{first_name}]")
    Rails.logger.info("SingleSignOnService.get_or_create_user last_name: [#{last_name}]")

    Rails.logger.info("SingleSignOnService.get_or_create_user - 1")
    user = AdminUser.find_by_email(email.downcase)
    Rails.logger.info("SingleSignOnService.get_or_create_user - 2")
    return user if user.present?
    Rails.logger.info("SingleSignOnService.get_or_create_user - 3")
    AdminUser.create!(
      email: email.downcase,
      first_name: first_name,
      last_name: last_name,
      password: SecureRandom.hex
    )
  end

  def email
    request.headers[EnvService.saml_email_attribute]
  end

  def first_name
    request.headers[EnvService.saml_first_name_attribute]
  end
  
  def last_name
    request.headers[EnvService.saml_last_name_attribute]
  end

  private
  attr_accessor :request

end

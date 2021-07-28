class SingleSignOnService

  def self.get_or_create_user(request)
    email = request.headers[EnvService.saml_email_attribute]
    first_name = request.headers[EnvService.saml_first_name_attribute]
    last_name = request.headers[EnvService.saml_last_name_attribute]

    user = AdminUser.find_by_email(email)
    return user if user.present?

    AdminUser.create!(email: email, first_name: first_name, last_name: last_name, password: SecureRandom.hex)
  end

end

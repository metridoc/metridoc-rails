class EnvService

  def self.saml_email_attribute
    ENV['SAML_EMAIL_ATTRIBUTE']
  end

  def self.saml_first_name_attribute
    ENV['SAML_FIRST_NAME_ATTRIBUTE']
  end

  def self.saml_last_name_attribute
    ENV['SAML_LAST_NAME_ATTRIBUTE']
  end

  def self.saml_logout_url
    ENV['SAML_LOGOUT_URL']
  end
  
end

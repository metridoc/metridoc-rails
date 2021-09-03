class SingleSignOnController < ApplicationController

  def sso
  end

  def shib
    single_signon_servive = SingleSignOnService.new(request)

    Rails.logger.info("SingleSignOnController#shib - 1")
    admin_user = single_signon_servive.get_or_create_user
    Rails.logger.info("SingleSignOnController#shib - 2")
    sign_in(admin_user)
    Rails.logger.info("SingleSignOnController#shib - 3")
    session[:sso] = true
    Rails.logger.info("SingleSignOnController#shib - 4")
    redirect_to '/admin'
  end

  def logout
    Rails.logger.info("SingleSignOnController#logout - 5")
    redirect_url = session[:sso] && EnvService.saml_logout_url ? EnvService.saml_logout_url : "/"
    Rails.logger.info("SingleSignOnController#logout - 6")
    session[:sso] = nil
    Rails.logger.info("SingleSignOnController#logout - 7")
    sign_out(current_admin_user)
    Rails.logger.info("SingleSignOnController#logout - 8")
    redirect_to redirect_url
  end

end

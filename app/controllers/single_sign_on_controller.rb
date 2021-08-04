class SingleSignOnController < ApplicationController

  def shib
    admin_user = SingleSignOnService.get_or_create_user(request)
    sign_in(admin_user)
    session[:sso] = true
    redirect_to '/admin'
  end

  def logout
    redirect_url = session[:sso] && EnvService.saml_logout_url ? EnvService.saml_logout_url : "/"
    session[:sso] = nil
    sign_out(current_admin_user)
    redirect_to redirect_url
  end

end

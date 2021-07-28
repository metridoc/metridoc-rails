class SingleSignOnController < ApplicationController

  def shib
    admin_user = SingleSignOnService.get_or_create_user(request)
    sign_in(admin_user)
    redirect_to '/admin'
  end

end

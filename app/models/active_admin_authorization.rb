class ActiveAdminAuthorization < ActiveAdmin::AuthorizationAdapter

  def authorized?(action, subject = nil)
    return user.authorized?(action, subject)
  end

end

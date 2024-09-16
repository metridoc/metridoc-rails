class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  # Redirect all unauthorized access from logged in users to the admin about page
  def access_denied(exception)
    redirect_to admin_root_path, alert: exception.message
  end
end

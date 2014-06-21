class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :session_user
  def session_user
    @session_user ||= User.find_by_id(session[:user_id])
  end

end

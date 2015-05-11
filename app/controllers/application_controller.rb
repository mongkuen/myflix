class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :logged_in?, :current_user

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def logged_in?
    !!current_user
  end

  def require_user
    if !logged_in?
      flash[:danger] = "You must log in first"
      redirect_to root_path
    end
  end

  def home_redirect_if_authenticated
    redirect_to home_path if logged_in?
  end

end

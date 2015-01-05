class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  helper_method :current_user, :logged_in?
  
  def current_user
    return nil if session[:token].nil?
    @current_user ||= User.find_by_session_token(session[:token])
  end
  
  def logged_in?
    !!current_user
  end
  
  def login(user)
    @current_user = user
    session[:token] = user.reset_session_token!
  end
  
  def logout
    @current_user = nil
    session[:token] = nil
  end
  
  def require_logged_in
    unless logged_in?
      flash[:errors] = ["Please log in."]
      redirect_to new_session_url
    end
  end
  
  def require_logged_out
    if logged_in?
      flash[:errors] = ["Log out first."]
      redirect_to user_url(current_user)
    end
  end
  
  def require_same_user
    unless current_user && current_user.id == params[:id]
      flash[:errors] = ["You don't have permission to view this page."]
      redirect_to new_session_url unless current_user
      redirect_to user_url(current_user)
    end
  end
end

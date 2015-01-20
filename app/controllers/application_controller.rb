class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  helper_method :current_user, :logged_in?, :current_assignment
  
  def current_user
    return nil if session[:token].nil?
    @current_user ||= Session.find_user_by_session_token(session[:token])
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
    Session.find_by_token(session[:token]).destroy
    session[:token] = nil
    clear_current_assignment
  end
  
  def current_assignment
    return nil if session[:assignment].nil?
    @current_assignment ||= Assignment.find(session[:assignment])
  end
  
  def set_current_assignment(assignment)
    @current_assignment = assignment
    session[:assignment] = assignment.id
  end
  
  def clear_current_assignment
    session[:assignment] = nil
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
    unless logged_in? && current_user.id.to_s == params[:id]
      flash[:errors] = ["You don't have permission to view this page."] 
      redirect_to new_session_url unless logged_in?
      redirect_to user_url(current_user)
    end
  end
  
  def require_teacher
    if current_user.user_type == "Student"
      flash[:errors] = ["Must be a teacher to do that."]
      redirect_to user_url(current_user)
    end
  end
end

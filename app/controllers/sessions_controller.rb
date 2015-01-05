class SessionsController < ApplicationController
  before_filter :require_logged_in, only: :destroy
  before_filter :require_logged_out, except: :destroy
  
  def new
    @user = User.new
    
    render :new
  end
  
  def create
    un_or_email = params[:user][:un_or_email]
    password = params[:user][:password]
    @user = User.find_by_credentials(un_or_email, password)
    
    if @user
      login(@user)
      redirect_to user_url(@user)
    else
      flash.now[:errors] = ["Incorrect username/email or password."]
      render :new
    end
  end
  
  def destroy
    logout
    redirect_to new_session_url
  end
end

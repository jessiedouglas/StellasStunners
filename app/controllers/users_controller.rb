class UsersController < ApplicationController
  before_filter :require_same_user, only: [:show, :edit, :update]
  before_filter :require_logged_out, only: [:new, :create]
  
  def show
    @user = User.find(params[:id])
    
    if @user.user_type == "Teacher"
      @course_students = @user.sort_students_by_course
      @ordered_courses = @user.sort_courses
    elsif @user.user_type == "Student"
      @courses = @user.taken_courses.includes(:teacher)
    end
    
    render :show
  end
  
  def new
    @user = User.new
    
    render :new
  end
  
  def create
    @user = User.new(user_params)
    
    unless params[:user][:password] == params[:password_confirm]
      flash.now[:errors] = ["Passwords do not match"]
      render :new
      return
    end
    
    unless ["Student", "Teacher"].include?(params[:user][:user_type])
      flash.now[:errors] = ["Choose an account type."]
      render :new
      return
    end
    
    if @user.save
      login(@user)
      redirect_to user_url(@user)
    else
      flash.now[:errors] = @user.errors.full_messages
      render :new
    end
  end
  
  def edit
    @user = User.find(params[:id])
    
    render :edit
  end
  
  def update
    @user = User.find(params[:id])
    
    if @user.update(user_params)
      redirect_to user_url(@user)
    else
      flash.now[:errors] = @user.errors.full_messages
      render :edit
    end
  end
  
  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :user_type)
  end
end

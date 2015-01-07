class CoursesController < ApplicationController
  before_filter :require_logged_in, only: :create
  before_filter :require_involved_in_course, only: :show
  before_filter :require_course_creator, except: [:create, :show]
  
  def show
    @course = Course.find(params[:id])
    
    render :show
  end
  
  def create
    @course = current_user.taught_courses.new(course_params)
    
    if @course.save
      redirect_to course_url(@course)
    else
      flash[:errors] = @course.errors.full_messages
      redirect_to user_url(current_user)
    end
  end
  
  def edit
    @course = Course.find(params[:id])
    
    render :edit
  end
  
  def update
    @course = Course.find(params[:id])
    
    if @course.update(course_params)
      redirect_to course_url(@course)
    else
      flash.now[:errors] = @course.errors.full_messages
      render :edit
    end
  end
  
  def destroy
    Course.find(params[:id]).destroy
    redirect_to user_url(current_user)
  end
  
  private
  def course_params
    params.require(:course).permit(:title, :description)
  end
  
  def require_involved_in_course
    course = Course.find(params[:id])
    student_ids = course.students.select("users.id").to_a
    
    if current_user.user_type == "Teacher"
      unless course.teacher_id == current_user.id
        flash[:errors] = ["Must be involved in the course to view it"]
        redirect_to user_url(current_user) 
      end
    elsif current_user.user_type == "Student"
      unless student_ids.include?(current_user.id)
        flash[:errors] = ["Must be involved in the course to view it"]
        redirect_to user_url(current_user) 
      end
    end
  end
  
  def require_course_creator
    course = Course.find(params[:id])
    unless course.teacher_id == current_user.id
      flash[:errors] = ["Must be the creator of the course"]
      redirect_to user_url(current_user)
    end
  end
end

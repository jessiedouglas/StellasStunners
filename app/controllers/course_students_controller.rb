class CourseStudentsController < ApplicationController
  before_filter :require_logged_in, only: :create
  before_filter :require_teacher_or_student, only: :destroy
  
  def create
    if current_user.user_type == "Student"
      @course = Course.find(params[:course_code])
      @link = @course.links_with_students.new(student: current_user)
      
      unless @link.save
        flash[:errors] = ["Course doesn't exist."]
      end
      
      redirect_to user_url(current_user)
    else
      @course = Course.find(params[:course_id])
      @link = @course.links_with_students.new(student_id: params[:student_id])
    
      unless @link.save
        flash[:errors] = @link.errors.full_messages
      end
    
      redirect_to course_url(@course)
    end
  end
  
  def destroy
    CourseStudents.find(params[:id]).destroy
    redirect_to user_url(current_user)
  end
  
  private
  def link_params
    params.require(:course_students).permit(:course_id, :student_id)
  end
  
  def require_teacher_or_student
    link = CourseStudents.find(params[:id])
    
    if current_user.user_type == "Teacher"
      user_courses = current_user.taught_courses
      unless user_courses.include?(link.course)
        flash[:errors] = ["Can't remove a student from another teacher's course."]
        redirect_to user_url(current_user)
      end
    elsif current_user.user_type == "Student"
      unless current_user.id == link.student_id
        flash[:errors] = ["Can't remove another student from a course."]
        redirect_to user_url(current_user)
      end
    end
  end
end

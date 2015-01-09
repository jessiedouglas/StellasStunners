class CourseStudentsController < ApplicationController
  before_filter :require_logged_in, only: :create
  before_filter :require_teacher_or_student, only: :destroy
  
  def create
    if current_user.user_type == "Teacher"
      course = Course.find(params[:course_students][:course_id])
      unless current_user.taught_courses.include?(course)
        flash[:errors] = ["Error. Course or student doesn't exist."]
        redirect_to user_url(current_user)
      end
      
      @link = CourseStudents.new(link_params)
    elsif current_user.user_type == "Student"
      course = Course.find_by_course_code(params[:course_code])
      @link = course.links_with_students.new(student: current_user)
    end
    
    unless @link.save
      flash[:errors] = ["Error. Course or student doesn't exist."]
    end
    
    redirect_to user_url(current_user)
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

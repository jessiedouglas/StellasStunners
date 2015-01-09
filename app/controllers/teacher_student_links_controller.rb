class TeacherStudentLinksController < ApplicationController
  before_filter :require_logged_in, only: :create
  before_filter :require_teacher_or_student, only: :destroy
  
  def create
    if current_user.user_type == "Teacher"
      @link = current_user.links_with_students.new(link_params)
    elsif current_user.user_type == "Student"
      @link = current_user.links_with_teachers.new(link_params)
    end
    
    unless @link.save
      flash[:errors] = ["Error. Student or teacher non-existant."]
    end
    
    redirect_to user_url(current_user)
  end
  
  def destroy
    TeacherStudentLink.find(params[:id]).destroy
    redirect_to user_url(current_user)
  end
  
  private
  def link_params
    if current_user.user_type == "Teacher"
      params.require(:teacher_student_link).permit(:student_id)
    elsif current_user.user_type == "Student"
      params.require(:teacher_student_link).permit(:teacher_id)
    end
  end
  
  def require_teacher_or_student
    link = TeacherStudentLink.find(params[:id])
    if current_user.user_type == "Teacher"
      unless current_user.id == link.teacher_id
        flash[:errors] = ["Can't remove a student from another teacher's list."]
        redirect_to user_url(current_user)
      end
    elsif current_user.user_type == "Student"
      unless current_user.id == link.student_id
        flash[:errors] = ["Can't remove another student from a teacher's list."]
        redirect_to user_url(current_user)
      end
    end
  end
end

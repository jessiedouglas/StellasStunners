class StudentAssignmentLinksController < ApplicationController
  before_filter :require_teacher_link, only: :create
  before_filter :require_creator, only: :destroy
  
  def create
    @assignment = Assignment.find(params[:assignment_id])
    @link = @assignment.links_with_students.new(student_id: params[:student_id])
    
    unless @link.save
      flash[:errors] = @link.errors.full_messages
    end
    
    redirect_to assignment_url(@assignment)
  end
  
  def destroy
    
  end
  
  private
  def require_teacher_link
    unless !!params[:student_id] || params[:student_id] == ""
      link = TeacherStudentLink.where("student_id = ? AND teacher_id = ?", params[:student_id], current_user.id)
      if link.empty?
        flash[:errors] = ["Can't assign things to someone who isn't your student."]
        redirect_to assignment_url(params[:assignment_id])
      end
    end
  end
  
  def require_creator
    assignment = Assignment.find(params[:assignment_id])
    unless assignment.teacher_id == current_user.id
      flash[:errors] = ["Stop that."]
      redirect_to user_url(current_user)
    end
  end
end

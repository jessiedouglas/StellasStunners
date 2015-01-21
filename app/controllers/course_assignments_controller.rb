class CourseAssignmentsController < ApplicationController
  before_filter :require_creator, only: :destroy
  before_filter :require_teacher, only: :create
  
  def create
    @assignment = Assignment.find(params[:assignment_id])
    @link = @assignment.links_with_courses.new(course_id: params[:course_id])
    
    unless @link.save
      flash[:errors] = @link.errors.full_messages
    end
    
    redirect_to assignment_url(@assignment)
  end
  
  def destroy
    link = CourseAssignment.find(params[:id])
    course = link.course
    link.destroy
    redirect_to course_url(course)
  end
  
  private
  def require_creator
    assignment = Assignment.find(params[:assignment_id])
    unless assignment.teacher_id == current_user.id
      flash[:errors] = ["Stop that."]
      redirect_to user_url(current_user)
    end
  end
end

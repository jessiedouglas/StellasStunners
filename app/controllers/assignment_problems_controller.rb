class AssignmentProblemsController < ApplicationController
  before_filter :require_assignment_creator, only: :destroy
  
  def create
    @link = current_assignment.links_with_problems.new(problem_id: params[:problem_id])
    unless @link.save
      flash[:errors] = @link.errors.full_messages
    end
    
    redirect_to problem_url(params[:problem_id])
  end
  
  def destroy
    link = AssignmentProblem.find(params[:id])
    assignment_id = link.assignment_id
    link.destroy
    redirect_to assignment_url(assignment_id)
  end
  
  private
  def require_assignment_creator
    link = AssignmentProblem.find(params[:id])
    unless link.problem.creator_id == current_user.id
      flash[:errors] = ["Stop that."]
      redirect_to user_url(current_user)
    end
  end
end

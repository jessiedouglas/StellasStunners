class AssignmentsController < ApplicationController
  before_filter :require_creator, only: [:index, :edit, :update, :destroy]
  before_filter :require_teacher, only: [:new, :create]
  before_filter :require_logged_in, only: :show
  
  def index
    @assignments = current_user.created_assignments
    
    render :index
  end
  
  def show
    @assignment = Assignment.find(params[:id]).include(:problems)
    
    render :show
  end
  
  def new
    @assignment = Assignment.new
    
    render :new
  end
  
  def create
    @assignment = current_user.created_assignments.new(assignment_params)
    
    if @assignment.save
      redirect_to assignment_url(@assignment)
    else
      flash.now[:errors] = @assignment.errors.full_messages
      render :new
    end
  end
  
  def edit
    @assignment = Assignment.find(params[:id])
    
    render :edit
  end
  
  def update
    @assignment = Assignment.find(params[:id])
    
    if @assignment.update(assignment_params)
      redirect_to assignment_url(@assignment)
    else
      flash.now[:errors] = @assignment.errors.full_messages
      render :edit
    end
  end
  
  def destroy
    Assignment.find(params[:id]).destroy
    redirect_to user_url(current_user)
  end
  
  private
  def assignment_params
    params.require(:assignment).permit(:title, :description, :due_date)
  end
  
  def require_creator
    assignment = Assignment.find(params[:id])
    unless assignment.teacher_id == current_user.id
      flash[:errors] = ["Can't edit someone else's assignment."]
      redirect_to user_url(current_user)
    end
  end
end
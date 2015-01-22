class ProblemsController < ApplicationController
  before_filter :require_teacher, only: [:index, :show, :new, :create]
  before_filter :require_creator, only: [:edit, :update]
  
  def index
    @problems = Problem.where(is_original: true)
    
    render :index
  end
  
  def show
    @problem = Problem.find(params[:id])
    
    if !!current_assignment
      @already_added = current_assignment.problems.include?(@problem)
    end
    
    render :show
  end
  
  def new
    @problem = Problem.new
    
    render :new
  end
  
  def create
    @problem = current_user.created_problems.new(problem_params)
    @problem.is_original = true
    
    if @problem.save
      redirect_to problem_url(problem)
    else
      flash.now[:errors] = @problem.errors.full_messages
      render :new
    end
  end
  
  def edit
    @problem = Problem.find(params[:id])
    
    render :edit
  end
  
  def update
    @problem = Problem.find(params[:id])
    
    if @problem.in_use?(current_user)
      old_problem = @problem
      old_problem.is_original = false
      old_problem.save!
      
      @problem = current_user.created_problems.new(problem_params)
      @problem.is_original = true #edited version becomes the one people see when searching
      
      if @problem.save
        @problem.ensure_problem_links_changed(old_problem, current_user)
        redirect_to problem_url(@problem)
      end
    else
      if @problem.update(problem_params)
        redirect_to problem_url(@problem)
      end
    end
    
    flash.now[:errors] = @problem.errors.full_messages
    render :edit
  end
  
  private
  def problem_params
    params.require[:problem].permit(:title, :body, :solution, :stella_number)
  end

  def require_creator
    problem = Problem.find(params[:id])
    unless problem.creator_id == current_user.id
      flash[:errors] = ["Can't edit a problem you didn't create."]
      redirect_to problem_url(problem)
    end
  end
end

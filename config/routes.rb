Rails.application.routes.draw do
  resource :session, only: [:new, :create, :destroy]
  
  resources :users, except: [:destroy, :index]
  
  resources :teacher_student_links, only: [:create, :destroy]
  
  resources :courses, except: [:index, :new] do
    resources :course_students, only: :create
  end
  
  resources :course_students, only: [:create, :destroy]
  
  resources :assignments do
    resources :course_assignments, only: :create
    resources :student_assignment_links, only: :create
    member do
      get 'set_as_current_assignment', as: 'set_current'
    end
  end
  
  resources :problems, except: :destroy do
    resources :assignment_problems, only: :create
  end
  
  resources :student_assignment_links, only: :destroy
  
  resources :assignment_problems, only: :destroy
  
  resources :course_assignments, only: :destroy
end

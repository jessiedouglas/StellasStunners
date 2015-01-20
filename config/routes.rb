Rails.application.routes.draw do
  resource :session, only: [:new, :create, :destroy]
  
  resources :users, except: [:destroy, :index]
  
  resources :teacher_student_links, only: [:create, :destroy]
  
  resources :courses, except: [:index, :new]
  
  resources :course_students, only: [:create, :destroy]
  
  resources :assignments
  
  resources :problems, except: :destroy
  
  resources :student_assignment_links, only: [:create, :destroy]
  
  resources :assignment_problems, only: [:create, :destroy]
end

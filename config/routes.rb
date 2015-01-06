Rails.application.routes.draw do
  resource :session, only: [:new, :create, :destroy]
  resources :users, except: [:destroy, :index]
  resources :teacher_student_links, only: [:create, :destroy]
end

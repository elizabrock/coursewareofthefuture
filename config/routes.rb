Coursewareofthefuture::Application.routes.draw do
  root 'courses#show'

  devise_for :students, controllers: { omniauth_callbacks: :omniauth_callbacks }
  devise_scope :student do
    get 'sign_in', :to => 'devise/sessions#new', :as => :new_student_session
    delete 'sign_out', :to => 'devise/sessions#destroy', :as => :destroy_student_session
  end

  resources :student_profiles, except: [:destroy], path: :students
  resource :calendar, only: [:show]
  resources :assignments, only: [:index, :show]
  resources :materials, only: [:index, :show]

  devise_for :instructors, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
end

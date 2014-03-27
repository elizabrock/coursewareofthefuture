Coursewareofthefuture::Application.routes.draw do
  root 'home#index'

  devise_for :users, controllers: { omniauth_callbacks: :omniauth_callbacks }
  devise_scope :user do
    get 'sign_in', :to => 'devise/sessions#new', :as => :new_user_session
    delete 'sign_out', :to => 'devise/sessions#destroy', :as => :destroy_user_session
  end

  resources :courses, except: [:edit, :update, :destroy] do
    resources :assignments, except: [:edit, :update, :destroy] do
      get :select, on: :collection
    end
    get :calendar, to: 'events#index'
    resources :enrollments, only: [:index, :create]
    resources :events, only: [:new, :create]
    resources :materials, only: [:index, :show], constraints: { id: /.*/ }
    resources :quizzes, only: [:show]
    resources :covered_materials, only: [:create]
  end
  resource :enrollment, only: [:new]
  resources :self_reports, only: [:new, :create]
  resources :student_profiles, except: [:destroy], path: :students
  resources :users, except: [:destroy] do
    member do
      post :instructify
    end
  end
end

Coursewareofthefuture::Application.routes.draw do
  root 'home#index'

  devise_for :users, controllers: { omniauth_callbacks: :omniauth_callbacks }
  devise_scope :user do
    get 'sign_in', :to => 'devise/sessions#new', :as => :new_user_session
    delete 'sign_out', :to => 'devise/sessions#destroy', :as => :destroy_user_session
  end

  resources :courses, except: [:create, :edit, :update, :destroy] do
    resources :enrollments, only: [:index]
    resources :materials, only: [:index, :show], constraints: { id: /.*/ }
    resource :calendar, only: [:show]
    resources :assignments, only: [:index, :show]
  end
  resource :enrollment, only: [:new]
  resources :users, except: [:destroy] do
    member do
      post :instructify
    end
  end
end

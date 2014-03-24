Coursewareofthefuture::Application.routes.draw do
  root 'courses#show'

  devise_for :users, controllers: { omniauth_callbacks: :omniauth_callbacks }
  devise_scope :user do
    get 'sign_in', :to => 'devise/sessions#new', :as => :new_user_session
    delete 'sign_out', :to => 'devise/sessions#destroy', :as => :destroy_user_session
  end

  resources :users, except: [:destroy] do
    member do
      post :instructify
    end
  end
  resource :calendar, only: [:show]
  resources :assignments, only: [:index, :show]
  resources :materials, only: [:index, :show], constraints: { id: /.*/ }
end

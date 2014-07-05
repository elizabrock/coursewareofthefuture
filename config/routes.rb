Coursewareofthefuture::Application.routes.draw do
  root 'home#index'

  devise_for :users, controllers: { omniauth_callbacks: :omniauth_callbacks }
  devise_scope :user do
    get 'sign_in', :to => 'devise/sessions#new', :as => :new_user_session
    delete 'sign_out', :to => 'devise/sessions#destroy', :as => :destroy_user_session
  end

  resources :courses, except: [:destroy] do
    resources :assignments, except: [:destroy]
    get :calendar, to: 'events#index'
    resources :enrollments, only: [:index, :create]
    resources :events, only: [:new, :create]
    get '/materials/:material_fullpath/slides', to: "slides#show", constraints: { material_fullpath: /.*\.md/ }
    get '/materials/:material_fullpath.md/:asset_file', to: "slides#asset", constraints: { material_fullpath: /.*/ }
    resources :materials, only: [:show, :index], constraints: { id: /.*/ } do
      resource :slides, only: :show
    end
    resources :covered_materials, only: [:create, :update]
    resources :quizzes, except: [:index, :show, :destroy] do
      member do
        get :grade
      end
      resource :quiz_submission, only: [:edit, :update, :show], as: :submission, path: :s
    end
  end
  resource :enrollment, only: [:new]
  resource :irc, only: :show, controller: :irc
  resources :milestone_submissions, only: [:create]
  resources :question_grades, only: [:edit, :update]
  resources :read_materials, only: [:create]
  resources :self_reports, except: [:destroy]
  resources :users, except: [:destroy] do
    member do
      post :instructify
      post :observify
    end
  end
  resource :instructor, only: [] do
    member do
      post :destudentify
      post :studentify
    end
  end
  get '/theme/css/:filename', to: redirect{ |params, req| "/assets/theme/#{params[:filename]}.#{params[:format]}" }
  get '/js/*filename', to: redirect{ |params, req| "/assets/theme/#{params[:filename]}.#{params[:format]}" }
end

Coursewareofthefuture::Application.routes.draw do
  root 'courses#show'

  devise_for :students, controllers: { registrations: :registrations }
  resources :students, only: [:index, :show]
  resource :calendar, only: [:show]
  resources :assignments, only: [:index, :show]
  resources :materials, only: [:index, :show]

  devise_for :instructors, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
end

Coursewareofthefuture::Application.routes.draw do
  devise_for :instructors
  root 'home#index'

  devise_for :students, controllers: { registrations: :registrations }
  resources :students, only: [:index, :show]
end

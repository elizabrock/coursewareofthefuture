Coursewareofthefuture::Application.routes.draw do
  root 'home#index'

  devise_for :students, controllers: { registrations: :registrations }
  resources :students, only: [:index, :show]
end

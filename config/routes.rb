Rails.application.routes.draw do
  namespace :api do
    resources :posts, only: :show
  end

  resources :apis, only: :index

  root 'posts#index'
end

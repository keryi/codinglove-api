Rails.application.routes.draw do
  namespace :api do
    resources :posts, only: :show
  end

  root 'posts#index'
end

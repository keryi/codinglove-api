Rails.application.routes.draw do
  namespace :api do
    resources :posts, only: :show do
      collection do
        get :random
      end
    end
  end

  resources :apis, only: :index

  root 'posts#index'
end

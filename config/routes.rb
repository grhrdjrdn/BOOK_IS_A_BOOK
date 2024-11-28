Rails.application.routes.draw do
  # resources :flats
  devise_for :users
  root to: "books#index"
  get "/dashboard", to: "pages#dashboard"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  resources :books do
    resources :requests, only: [:new, :create]
  end

  resources :requests, only: [:show] do
    resources :messages, only: :create
    patch :approve
    patch :deny
  end

  resources :users
end

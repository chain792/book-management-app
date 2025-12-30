Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root "books#index"
  resources :users, only: %i[index new create show] do
    member do
      get :following
      get :follower
    end
  end
  resources :books do
    collection { get :search }
    resources :comments, only: %i[create update destroy], shallow: true
  end
  resources :categories, only: %i[index show]
  resources :likes, only: %i[create destroy]
  resources :relationships, only: %i[create destroy]
  resource :profile, only: %i[show edit update]
  get "login", to: "user_sessions#new"
  post "login", to: "user_sessions#create"
  delete "logout", to: "user_sessions#destroy"
  post "guest_login", to: "user_sessions#guest_login"
  get "/auth/:provider/callback" => "oauths#create"
  get "/auth/failure" => "oauths#failure"
  get "/terms" => "static_pages#terms"
  get "/privacy" => "static_pages#privacy"
end

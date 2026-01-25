Rails.application.routes.draw do
  resource :session
  resources :passwords, param: :token
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
  post "guest_login", to: "sessions#guest_login"
  get "login", to: "sessions#new"
  delete "logout", to: "sessions#destroy"

  get "/auth/:provider/callback" => "oauths#create"
  get "/auth/failure" => "oauths#failure"
  get "/terms" => "static_pages#terms"
  get "/privacy" => "static_pages#privacy"
end

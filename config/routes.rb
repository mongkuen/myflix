Myflix::Application.routes.draw do
  get 'ui(/:action)', controller: 'ui'
  root  to: 'pages#passthrough'
  get '/home', to: 'videos#index'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'
  get '/register', to: 'users#new'
  get '/forgot_password', to: 'password_resets#new'
  post '/forgot_password', to: 'password_resets#create'
  get '/confirmation', to: 'password_resets#confirmation'
  get '/reset_password/:id', to: 'password_resets#edit', as: 'reset_password'
  post '/reset_password', to: 'password_resets#update', as: 'post_reset_password'
  get '/token_expired', to: 'password_resets#token_expired'

  get '/my_queue', to: 'queue_items#index'
  post '/my_queue', to: 'queue_items#update'
  get '/invite', to: 'invites#new'
  post '/invite', to: 'invites#create', as: 'invites'
  get '/people', to: 'followerships#index'
  resources :users, only: [:create, :show]
  resources :videos, only: [:show] do
    collection do
      get '/search', to: 'videos#search'
    end

    member do
      post '/review', to: 'reviews#create'
    end
  end
  resources :categories, only: [:show]
  resources :queue_items, only: [:create, :destroy]
  resources :followerships, only: [:create, :destroy]

  namespace :admin do
    resources :videos, only: [:new, :create]
  end
end

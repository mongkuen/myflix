Myflix::Application.routes.draw do
  get 'ui(/:action)', controller: 'ui'
  root  to: 'pages#passthrough'
  get '/home', to: 'videos#index'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  post '/logout', to: 'sessions#destroy'
  get '/register', to: 'users#new'
  get '/my_queue', to: 'queue_items#index'
  post '/my_queue', to: 'queue_items#update'
  resources :users, only: [:create]

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

end

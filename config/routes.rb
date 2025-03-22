Rails.application.routes.draw do
  get 'searches/index'
  get 'searches/show'
  get 'searches/new'
  get 'searches/create'
  devise_for :users
  root to: "pages#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'search', to: 'searches#index', as: :search
  get 'searches/suggestions', to: 'searches#suggestions'
  resources :searches, only: [:show] do
    member do
      get 'countries', to: 'searches#countries', as: :countries
      get 'timeframe', to: 'searches#timeframe', as: :timeframe
      get 'analyze', to: 'searches#analyze', as: :analyze
    end
  end
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end

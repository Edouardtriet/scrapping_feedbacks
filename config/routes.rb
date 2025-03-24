Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'search', to: 'searches#index', as: :search
  get 'searches/suggestions', to: 'searches#suggestions'
  resources :searches, only: [:show] do
    member do
      get 'countries', to: 'searches#countries', as: :countries
      get 'timeframe', to: 'searches#timeframe', as: :timeframe
      get 'save_search', to: 'searches#save_search', as: :save_search
      get 'analyze', to: 'searches#analyze', as: :analyze
    end
  end
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end

Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"

  resources :searches do
    member do
      get 'save_search'
      get 'analyze'
    end
  end

  # Wizard routes are handled by the Wicked gem automatically
end

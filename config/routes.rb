Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"

  resources :searches do
    member do
      get 'save_search'
      get 'analyze'
      get 'download_csv'
    end
  end

  # In config/routes.rb
  get 'reviews_:id.csv', to: 'searches#download_csv'

  # Wizard routes are handled by the Wicked gem automatically
end

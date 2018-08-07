Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # resources :cita, only: [:index]
  post "/", to: "cita#index"

  namespace :api do
    resources :blocks, only: [:index]
    resources :transactions, only: [:index]
    resources :statistics, only: [:index]
    resources :status, only: [:index]
    resources :sync_errors, only: [:index]
  end
end

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # resources :cita, only: [:index]
  root to: "application#not_found"
  post "/", to: "cita#index"

  namespace :api do
    resources :blocks, only: [:index]
    resources :transactions, only: [:index]
    resources :statistics, only: [:index]
    resources :status, only: [:index]
    resources :sync_errors, only: [:index]
    get "erc20/transfers", to: "erc20_transfers#index"
    get "transactions/:hash", to: "transactions#show"
    get "event_logs/:address", to: "event_logs#show"
  end

  health_check_routes

  # 404
  match '*path', via: :all, to: 'application#not_found'
end

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  require "sidekiq/web"
  mount Sidekiq::Web => "/sidekiq"

  # resources :cita, only: [:index]
  root to: "application#homepage"
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
    get "info/url", to: "info#url"

    namespace :v2 do
      resources :blocks, only: [:index]
      resources :transactions, only: [:index]
    end
  end

  health_check_routes

  # 404
  match '*path', via: :all, to: 'application#not_found'
end

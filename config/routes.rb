Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  require "sidekiq/web"
  mount Sidekiq::Web => "/sidekiq"

  # resources :cita, only: [:index]
  root to: "application#homepage"
  post "/", to: "cita#index"

  namespace :api, defaults: { format: :json } do
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

    post "search/establish_total_amount", to: "search#establish_total_amount"
    post "search/establish_summary", to: "search#establish_summary"
    post "search/transfer_summary", to: "search#transfer_summary"
    post "search/cash_total_amount", to: "search#cash_total_amount"
    post "search/cash_summary", to: "search#cash_summary"
    post "search/transfer_tb_balance", to: "search#transfer_tb_balance"
    post "search/credit_balance", to: "search#credit_balance"

    post "search/hold_list", to: "front_end#hold_list"
    post "search/transfer_list", to: "front_end#transfer_list" # 融资或流转列表

    post "query_cita", to: "query_cita#index"

    get "decode_transactions/:tx_hash", to: "decode_transactions#show"

    get "ouye/credit_total", to: "ouye#credit_total"
    get "ouye/credit_list", to: "ouye#credit_list"
    get "ouye/ent_open_tongbaos", to: "ouye#ent_open_tongbaos"
    get "ouye/tongbao_total", to: "ouye#tongbao_total"
    get "ouye/tongbao_list", to: "ouye#tongbao_list"
    get "ouye/tongbao_detail", to: "ouye#tongbao_detail"
    get "ouye/platforms", to: "ouye#platforms"

    post "storages/callback/:record_id", to: "storages#callback"
    post "platforms", to: "platforms#create"
  end

  health_check_routes

  # 404
  match '*path', via: :all, to: 'application#not_found'
end

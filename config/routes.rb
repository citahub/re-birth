Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :rpc_api do
    namespace :v1 do
      # resources :cita, only: [:index]
      post "cita", to: "cita#index"
    end
  end
end

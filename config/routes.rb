Rails.application.routes.draw do
get "/favicon.ico", to: proc { [ 204, {}, [] ] }
# Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
root "static_pages#top"

resources :diagnoses, only: [ :new, :create ] do
  member do
    get :result
  end
end
resources :facilities, only: [ :show ] do
  resources :favorites, only: [ :create, :destroy ], shallow: true   # shallow: trueを追加して、favoritesのルーティングを簡略化
end
resources :users, only: [ :new, :create ]
resource :login, only: [ :new, :create ]
resource :logout, only: [ :destroy ]



  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end

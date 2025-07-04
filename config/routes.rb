Rails.application.routes.draw do
  mount ActionCable.server => '/cable'

  devise_for :users
  
  resources :clubs do
    member do
      patch :update_banner
      post :send_invitation
      post :accept_invitation
      get :new_invite
      get :join
    end

    collection do
      get :join, as: :join
      post :accept_invitation
    end

    resources :readings, only: [:show, :new, :create, :edit, :update, :destroy] do
      member do
        patch :mark_as_current
      end
    end
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  root "home#index"
end

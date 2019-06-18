Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      get '/personnel/search' => 'personnel#search'

      resources :albums, only: [:show]
      resources :personnel, only: [:show]
      resources :song_requests, only: [:index, :create]

      resources :songs, only: [:index, :show, :update] do
        resources :albums, only: [:create]
        resources :credits, only: [:index]
        post '/albums/search' => 'albums#search'
      end

      resources :episodes, only: [:index, :show, :create, :update] do
        resources :songs, only: [:create]
      end

      resources :shows, only: [:index]

      resources :stats, only: [:show]

      post   "/login"       => "sessions#create"
      delete "/logout"      => "sessions#destroy"

      get "/auth" => "users#auth"
    end
  end


end

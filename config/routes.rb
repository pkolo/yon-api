Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      resources :albums, only: [:show]
      resources :personnel, only: [:show]

      resources :songs, only: [:index, :show] do
        resources :albums, only: [:create]
        post '/albums/search' => 'albums#search'
      end

      resources :episodes, only: [:show, :create, :update] do
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

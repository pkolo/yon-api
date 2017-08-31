Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      resources :songs, only: [:index, :show]
      resources :albums, only: [:show]
      resources :personnel, only: [:show]
      resources :episodes, only: [:show, :create] do
        resources :songs, only: [:create]
      end
      post   "/login"       => "sessions#create"
      delete "/logout"      => "sessions#destroy"
    end
  end


end

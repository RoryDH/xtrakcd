Rails.application.routes.draw do
  scope :api do
    scope :v1 do
      resources :comics, path: 'c', only: [:show, :index] do
        member do
          post 'favourite' => 'favourites#create'
          delete 'favourite' => 'favourites#destroy'
        end
        collection do
          get 'favourites' => 'favourites#index'
          get 'random'
          get 'latest'
        end
      end

      resources :schedules, path: 's', only: [:index, :show, :create, :update, :destroy]
      resources :destinations, path: 'd', only: [:index, :show, :create, :update, :destroy] do
        post :test, on: :member
      end
    end

    devise_for :users, :skip => [:registrations, :sessions]
    as :user do
      # Sessions
      post 'in'    => 'sessions#create'
      delete 'out' => 'sessions#destroy'
      get 'me'     => 'sessions#me'

      # Registrations
      post '/me'   => 'registrations#create'
      patch '/me'  => 'registrations#update'
      put '/me'    => 'registrations#update'
      delete '/me' => 'registrations#destroy'
    end

    root to: 'misc#index', as: :api_root
  end

end

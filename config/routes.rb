Rails.application.routes.draw do
  scope :api do
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

    devise_for :users, :skip => [:registrations, :sessions]
    as :user do
      # Sessions
      post "in"    => "sessions#create", as: :user_session
      delete "out" => "sessions#destroy", as: :destroy_user_session

      # Registrations
      post "/register" =>   "registrations#create", as: :user_registration
      patch "/register" =>  "registrations#update"
      put "/register" =>    "registrations#update"
      delete "/register" => "registrations#destroy"

      # Custom
      get "me", to: "registrations#me"
    end
  end
end

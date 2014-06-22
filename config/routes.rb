Rails.application.routes.draw do
  scope :api do
    resources :comics, only: [:show, :index] do
      member do
        post 'favourite' => 'favourites#create'
        delete 'favourite' => 'favourites#destroy'
      end
      collection do
        get 'favourites' => 'favourites#index'
      end
    end

    devise_for :users
  end
end

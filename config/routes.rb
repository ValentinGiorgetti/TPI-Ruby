Rails.application.routes.draw do

  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }
  devise_scope :user do
    authenticated :user do
      root 'appointments#index', as: :authenticated_root
    end
  
    unauthenticated do
      root 'devise/sessions#new', as: :unauthenticated_root
    end
  end

  resources :users
  resource :user, only: [:show, :edit, :update]
  get 'my_profile', to: 'users#show'
  get 'new_users', to: 'users#new_users'

  resources :appointments do
    collection do
      match 'search' => 'appointments#index', via: [:get, :post], as: :search
    end
  end

  resources :appointments
  match '/appointments_filtered', to: 'appointments#index', via: [:get, :post]
  get 'appointments_exporter/index'
  post 'appointments_exporter/submit'

  resources :professionals do
    collection do
      match 'search' => 'professionals#index', via: [:get, :post], as: :search
    end
  end

  resources :professionals do
    resources :appointments do
      collection do
        match 'search' => 'appointments#index', via: [:get, :post], as: :search
      end
    end
    post 'cancel_all_appointments', to: 'appointments#cancel_all'
    match 'appointments_filtered', to: 'appointments#index', via: [:get, :post]
  end

  scope :api do
    get 'professionals', to: 'api#get_professionals'
    get 'appointments', to: 'api#get_appointments'
  end
  
end
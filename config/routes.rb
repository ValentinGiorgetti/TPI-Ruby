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

  resources :appointments
  match '/appointments_filtered', to: 'appointments#index', via: [:get, :post]
  get 'appointments_exporter/index'
  post 'appointments_exporter/submit'

  resources :professionals do
    resources :appointments
    post 'cancel_all_appointments', to: 'appointments#cancel_all'
    match 'appointments_filtered', to: 'appointments#index', via: [:get, :post]
  end
  
end
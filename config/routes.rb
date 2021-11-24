Rails.application.routes.draw do
  get 'appointments_exporter/index'
  post 'appointments_exporter/submit'
  devise_for :users
  devise_scope :user do
    authenticated :user do
      root 'appointments#index', as: :authenticated_root
    end
  
    unauthenticated do
      root 'devise/sessions#new', as: :unauthenticated_root
    end
  end
  resources :appointments
  resources :professionals do
    resources :appointments
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end

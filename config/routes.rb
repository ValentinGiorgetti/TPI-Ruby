Rails.application.routes.draw do

  get 'appointments_exporter/index'
  post 'appointments_exporter/submit'

  scope "/admin" do
    resources :users
  end

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

  post "/professionals/:professional_id/cancel_all_appointments", to: "appointments#cancel_all"
  match "/professionals/:professional_id/appointments_filtered", to: "appointments#index", via: [:get, :post]
  match "/appointments_filtered", to: "appointments#index", via: [:get, :post]
  
end

Rails.application.routes.draw do
  get 'appointments_exporter/index'
  post 'appointments_exporter/submit'
  devise_for :users
  resources :appointments
  resources :professionals do
    resources :appointments
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end

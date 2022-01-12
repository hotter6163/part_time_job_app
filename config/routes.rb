Rails.application.routes.draw do
  resources :company_registration, only: [:new, :create]
  devise_for :users, controllers: { registrations: 'users/registrations' }
  root 'static_pages#home'
end

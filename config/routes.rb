Rails.application.routes.draw do
  root 'static_pages#home'
  resources :users, only: [:new, :create, :show]
  resources :companies, only: [:new, :create, :show] 
end

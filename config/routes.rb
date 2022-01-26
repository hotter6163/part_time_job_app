Rails.application.routes.draw do
  # 企業登録のためのルーティング
  resources :company_registration, only: [:new, :create]
  
  resources :branches, only: [:show] do
    member do
      get :add_employee
      post :send_email
    end
  end
  resources :relationships, only: [:new, :create]
  devise_for :users, controllers: { 
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }
  root 'static_pages#home'
end

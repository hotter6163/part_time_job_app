Rails.application.routes.draw do
  
  # 企業登録のためのルーティング
  get 'company_registration/input_branch', to: 'company_registration#input_branch', as: :input_branch
  post 'company_registration/input_branch', to: 'company_registration#create_branch', as: :create_branch
  get 'company_registration/input_company', to: 'company_registration#input_company', as: :input_company
  post 'company_registration/input_company', to: 'company_registration#create_company', as: :create_company
  get 'company_registration/select_user', to: 'company_registration#select_user', as: :select_user
  post 'company_registration/select_user', to: 'company_registration#selecter', as: :selecter
  
  
  devise_for :users, controllers: { 
    registrations: 'users/registrations' 
  }
  root 'static_pages#home'
end

Rails.application.routes.draw do
  get 'company_registration/input_branch', to: 'company_registration#input_branch', as: :input_branch_company_registration
  post 'company_registration/input_branch', to: 'company_registration#create_branch', as: :create_branch_company_registration
  get 'company_registration/input_company', to: 'company_registration#input_company', as: :input_company_company_registration
  post 'company_registration/input_company', to: 'company_registration#create_company', as: :create_company_company_registration
  get 'company_registration/select_user', to: 'company_registration#select_user', as: :select_user_company_registration
  post 'company_registration/select_user', to: 'company_registration#selecter', as: :selecter_company_registration
  
  devise_for :users, controllers: { 
    registrations: 'users/registrations' 
  }
  root 'static_pages#home'
end

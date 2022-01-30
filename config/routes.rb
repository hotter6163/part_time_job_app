Rails.application.routes.draw do
  # 企業登録のためのルーティング
  get   'company_registrations/new_company',  to: 'company_registrations#new',            as: :new_company_registration
  post  'company_registrations/new_company',  to: 'company_registrations#check_company',  as: :check_company_registration
  get   'company_registrations/new_user',     to: 'company_registrations#new_user',       as: :new_user
  get   'company_registrations/exist_user',   to: 'company_registrations#exist_user',     as: :exist_user
  post  'company_registrations',              to: 'company_registrations#create',         as: :company_registrations
  
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

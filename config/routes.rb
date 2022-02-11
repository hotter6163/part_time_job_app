Rails.application.routes.draw do
  # 企業登録のためのルーティング
  get   'company_registrations/new_company',  to: 'company_registrations#new',            as: :new_company_registration
  post  'company_registrations/new_company',  to: 'company_registrations#check_company',  as: :check_company_registration
  get   'company_registrations/new_user',     to: 'company_registrations#new_user',       as: :new_user
  get   'company_registrations/exist_user',   to: 'company_registrations#exist_user',     as: :exist_user
  post  'company_registrations',              to: 'company_registrations#create',         as: :company_registrations
  
  # シフト提出
  get   'shift_submissions/:id',      to: 'shift_submissions#new_shift',    as: :new_shift_submission
  post  'shift_submissions/:id',      to: 'shift_submissions#create_shift', as: :shift_submissions
  get   'shift_submissions/:id/show', to: 'shift_submissions#show',         as: :shift_submission
  
  resources :branches, only: [:show] do
    member do
      get :add_employee
      post :send_email
      get "periods/:period_id",  to: 'branches#show_periods',  as: :periods
      get "date/:date",     to: 'branches#show_date',      as: :date
    end
  end
  
  resources :relationships, only: [:new, :create]
  devise_for :users, controllers: { 
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }
  root 'static_pages#home'
end

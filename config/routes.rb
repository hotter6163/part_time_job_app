Rails.application.routes.draw do
  resources :company_registration, only: [:new, :create] do 
    collection do
      post :create_branch
      post :create_user_select
    end
  end
  devise_for :users, controllers: { 
    registrations: 'users/registrations' 
  }
  root 'static_pages#home'
end

Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'

  resources :softwares do 
    resources :software_plans
  end

  resources :software_plans do
      resources :software_features
    end
    
  resources :features

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :users do
    resources :bank_details
  end

  resources :companies do
    resources :bank_details
    resources :subscriptions
  end
end

Rails.application.routes.draw do
  get 'stores/show'
  root to: 'home#index'

  devise_for :users, controllers: { 
    registrations: 'users/registrations', 
    sessions: 'users/sessions'
  }
  
  devise_scope :user do
    get 'profile', to:'users/sessions#profile'
  end

  resources :stores
end

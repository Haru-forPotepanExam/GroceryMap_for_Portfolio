Rails.application.routes.draw do
  root to: 'home#index'

  devise_for :users, controllers: { 
    registrations: 'users/registrations', 
    sessions: 'users/sessions'
  }
  
  devise_scope :user do
    get 'profile', to:'users/sessions#profile'
  end
  
end

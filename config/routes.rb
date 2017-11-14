Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  root to: 'static_pages#index'
  
  get '/redirect', to: 'events#redirect', as: 'redirect'
  get '/callback', to: 'events#callback', as: 'callback'
  get '/calendar', to: 'events#index', as: 'calendar'
  
  post '/users/sign_out', to: 'devise/sessions#destroy', as: 'log_out'

  
end

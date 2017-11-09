Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  root to: 'static_pages#index'
  
  get '/redirect', to: 'google_calendar#redirect', as: 'redirect'
  get '/callback', to: 'google_calendar#callback', as: 'callback'
  get '/calendar', to: 'googel_calendar#show', as: 'calendar'
  

  
end

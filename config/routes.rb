Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  root to: 'static_pages#index'

  get '/redirect', to: 'events#redirect', as: 'redirect'
  get '/callback', to: 'events#callback', as: 'callback'
  get '/calendar', to: 'events#index', as: 'calendar'

  post '/users/sign_out', to: 'devise/sessions#destroy', as: 'log_out'

  get '/learning-trails', to: 'learning_trails#index', as: 'learning_trails'
  get '/learning-trails/:id', to: 'learning_trails#show', constraints: { id: /[0-9]+(\%7C[0-9]+)*/ }
  get '/learning-trails/:name', to: 'learning_trails#show'

  post '/learning-trails/add', to: 'learning_trails#add', as: 'add_topic'
  post '/learning-trails/complete-task', to: 'learning_trails#complete_task', as: 'complete_task'
  post '/learning-trails/reset-task', to: 'learning_trails#reset_task', as: 'reset_task'
  post '/learning-trails/complete-goal', to: 'learning_trails#complete_goal', as: 'complete_goal'
  post '/learning-trails/reset-goal', to: 'learning_trails#reset_goal', as: 'reset_goal'

  # api routes
  get '/api/events', to: 'event_api#index'
end

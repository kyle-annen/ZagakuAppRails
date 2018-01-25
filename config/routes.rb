Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  root to: 'home#index'


  get '/callback', to: 'events#callback', as: 'callback'

  get '/control-panel', to: 'control_panel#index', as: 'control_panel'
  get '/control-panel/:page', to: 'control_panel#index'
  put '/control-panel/:page', to: 'control_panel#new'
  post '/control-panel', to: 'control_panel#update', as: 'control_panel_update'

  get '/control-panel/calendars/sync', to: 'control_panel#sync_calendars'
  delete '/control-panel/calendars/delete', to: 'control_panel#delete_calendar', as: 'delete_calendar'


  get '/calendar', to: 'events#index', as: 'calendar'
  post '/calendar', to: 'events#create'

  post '/users/sign_out', to: 'devise/sessions#destroy', as: 'log_out'

  get '/learning-trails', to: 'learning_trails#index', as: 'learning_trails'
  get '/learning-trails/:id', to: 'learning_trails#show', constraints: { id: /[0-9]+(\%7C[0-9]+)*/ }
  get '/learning-trails/:name', to: 'learning_trails#show'

  post '/learning-trails/add', to: 'learning_trails#add', as: 'add_topic'
  post '/learning-trails/complete-task', to: 'learning_trails#complete_task', as: 'complete_task'
  post '/learning-trails/reset-task', to: 'learning_trails#reset_task', as: 'reset_task'
  post '/learning-trails/complete-goal', to: 'learning_trails#complete_task', as: 'complete_goal'
  post '/learning-trails/reset-goal', to: 'learning_trails#reset_task', as: 'reset_goal'

  get '/api/events', to: 'event_api#index'
end

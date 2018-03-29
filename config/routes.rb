# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  integer = Regexp.new(/[0-9]+(%7C[0-9]+)*/)
  markdown = Regexp.new(/.md/)

  root to: 'home#index'

  get '/callback', to: 'events#callback', as: 'callback'

  get '/control-panel', to: 'control_panel#index', as: 'control_panel'
  get '/control-panel/:page', to: 'control_panel#index'
  put '/control-panel/:page', to: 'control_panel#new'
  post '/control-panel', to: 'control_panel#update', as: 'control_panel_update'

  get '/control-panel/calendars/sync', to: 'control_panel#sync_calendars'
  delete '/control-panel/calendars/delete', to: 'control_panel#delete_calendar', as: 'delete_calendar'

  get '/user/settings', to: 'user_settings#show', as: 'user_settings'

  get '/calendar', to: 'events#index', as: 'calendar'
  post '/calendar', to: 'events#create'

  post '/users/sign_out', to: 'devise/sessions#destroy', as: 'log_out'
  post '/user', to: 'user_settings#update', as: 'update_user'

  get '/learning-trails', to: 'learning_trails#index', as: 'learning_trails'
  get '/learning-trails/:id', to: 'learning_trails#show', constraint: { id: integer }
  get '/learning-trails/:name', to: 'learning_trails#show'

  get '/*topic_name/:name', to: 'learning_trails#show', constraint: { name: markdown }

  post '/learning-trails/add', to: 'learning_trails#add', as: 'add_topic'
  post '/learning-trails/complete-task', to: 'learning_trails#complete_task', as: 'complete_task'
  post '/learning-trails/reset-task', to: 'learning_trails#reset_task', as: 'reset_task'
  post '/learning-trails/complete-goal', to: 'learning_trails#complete_task', as: 'complete_goal'
  post '/learning-trails/reset-goal', to: 'learning_trails#reset_task', as: 'reset_goal'

  get '/api/events', to: 'event_api#index'

  get '*unmatched_route', to: redirect('/404')

end

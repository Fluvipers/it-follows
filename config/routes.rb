Rails.application.routes.draw do
  devise_for :users
  resources :lines

  get '/proposals/', to: 'line_entries#index', as: 'line_entries'
  get '/proposals/new/' , to: 'line_entries#new' , as: 'new_line_entries'
  post '/proposals/', to: 'line_entries#create'
  get '/proposals/:id/edit', to: 'line_entries#edit', as: 'edit_line_entry'

  get '/proposal/:id', to: 'line_entries#show', as: 'line_entry'

  #patch '/proposals/:id', to: 'line_entries#update'#, via: [:put, :patch]
  #put '/proposals/:id', to: 'line_entries#update'#, via: [:put, :patch]

  patch '/proposal/:id', controller: 'line_entries', action: :update #, via: [:put, :patch]
  put '/proposal/:id', controller: 'line_entries', action: :update #, via: [:put, :patch]

  root to: "home#index"
end

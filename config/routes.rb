Rails.application.routes.draw do

  devise_for :users, controllers: { sessions: "users/sessions"}
  resources :lines

  get '/:line_entries/', to: 'line_entries#index', as: 'line_entries', constraints: { line_entries: /\w+/}
  get '/:line_entries/new/' , to: 'line_entries#new' , as: 'new_line_entries', constraints: { line_entries: /\w+/}
  post '/:line_entries/', to: 'line_entries#create', constraints: { line_entries: /\w+/}
  get '/:line_entries/:id/edit', to: 'line_entries#edit', as: 'edit_line_entry', constraints: { line_entries: /\w+/}
  patch '/:line_entries/:id', to: 'line_entries#update', constraints: { line_entries: /\w+/}

  root to: "home#index"
end

Rails.application.routes.draw do
  devise_for :users
  resources :lines
  resources :proposals, except: [:destroy], controller: 'line_entries'

  root to: "home#index"

end

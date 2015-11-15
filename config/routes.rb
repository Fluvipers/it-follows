Rails.application.routes.draw do
  devise_for :users
  resources :lines

  root to: "home#index"

end

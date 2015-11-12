Rails.application.routes.draw do
  resources :lines

  root to: "home#index"

end

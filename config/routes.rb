Rails.application.routes.draw do
  resources :posts

  resources :authors, only: :show
end
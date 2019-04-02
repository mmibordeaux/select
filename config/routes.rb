Rails.application.routes.draw do
  devise_for :users
  resources :candidates
  resources :baccalaureats
  root to: 'candidates#index'
end

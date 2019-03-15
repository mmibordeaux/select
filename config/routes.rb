Rails.application.routes.draw do
  resources :candidates
  resources :baccalaureats
  root to: 'candidates#index'
end

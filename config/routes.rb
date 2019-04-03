Rails.application.routes.draw do
  resources :modifiers
  devise_for :users
  resources :candidates do
    collection do
      get :import
      post :import
    end
  end
  resources :baccalaureats
  root to: 'candidates#index'
end

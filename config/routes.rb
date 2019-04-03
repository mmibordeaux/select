Rails.application.routes.draw do
  devise_for :users
  resources :modifiers, :users, :baccalaureats
  resources :candidates do
    collection do
      get :import
      post :import
    end
  end
  root to: 'candidates#index'
end

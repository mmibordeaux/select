Rails.application.routes.draw do
  devise_for :users
  resources :modifiers, :users, :baccalaureats
  resources :candidates do
    collection do
      get :scholarship
      get :import
      post :import
      post :positionize
    end
  end
  root to: 'candidates#index'
end

Rails.application.routes.draw do
  devise_for :users
  resources :modifiers, :baccalaureats
  resources :users, only: [:index, :show]
  resources :candidates do
    collection do
      get :scholarship
      get :import
      get 'production/:production' => 'candidates#production', as: :production
      post :import
      post :positionize
    end
  end
  root to: 'candidates#index'
end

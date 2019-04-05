Rails.application.routes.draw do
  devise_for :users
  resources :modifiers, :baccalaureats, :users
  resources :candidates do
    collection do
      get :scholarship
      get :import
      get :my
      get 'production/:production' => 'candidates#production', as: :production
      post :import
      post :positionize
    end
  end
  root to: 'candidates#my'
end

Rails.application.routes.draw do
  devise_for :users
  resources :modifiers, :baccalaureats, :users
  namespace :candidates do
    get 'my' => 'my#index'
    get 'import' => 'operations#import'
    post 'import' => 'operations#import'
    post 'positionize' => 'operations#positionize', as: :positionize
    get 'production/:production' => 'production#index', as: :production
  end
  resources :candidates do
    collection do
      get :scholarship
    end
  end
  root to: 'candidates/my#index'
end

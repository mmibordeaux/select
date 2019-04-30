Rails.application.routes.draw do
  devise_for :users
  resources :modifiers, :baccalaureats, :users, :settings
  namespace :candidates do
    get 'my' => 'my#index'
    get 'import' => 'operations#import'
    post 'import' => 'operations#import'
    post 'positionize' => 'operations#positionize', as: :positionize
    get 'production/:production' => 'production#index', as: :production
    get 'stats' => 'stats#index', as: :stats
    scope :interviews do
      get 'stats' => 'interviews#stats', as: :interviews_stats
      get ':id' => 'interviews#show', as: :interview
      get ':id/print' => 'interviews#print', as: :print_interview
      put ':id' => 'interviews#update', as: nil
      patch ':id' => 'interviews#update', as: nil
      root to: 'interviews#index', as: :interviews
    end
    scope :selections do
      get 'stats' => 'selections#stats', as: :selections_stats
      root to: 'selections#index', as: :selections
    end
  end
  resources :candidates do
    collection do
      get :scholarship
    end
  end
  root to: 'candidates/my#index'
end

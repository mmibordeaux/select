Rails.application.routes.draw do
  devise_for :users
  resources :modifiers, :baccalaureats, :users, :settings
  namespace :candidates do
    get 'import' => 'operations#import'
    post 'import' => 'operations#import'
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
      get 'stats/tech' => 'selections#stats_tech', as: :selections_stats_tech
      get 'stats/gen' => 'selections#stats_gen', as: :selections_stats_gen
      root to: 'selections#index', as: :selections
    end
    scope :promotion do
      get 'stats' => 'promotion#stats', as: :promotion_stats
      get 'stats/tech' => 'promotion#stats_tech', as: :promotion_stats_tech
      get 'stats/gen' => 'promotion#stats_gen', as: :promotion_stats_gen
      put 'select/:candidate_id' => 'promotion#select', as: :promotion_select
      put 'unselect/:candidate_id' => 'promotion#unselect', as: :promotion_unselect
      root to: 'promotion#index', as: :promotion
    end
  end
  resources :candidates do
    collection do
      get :scholarship
    end
  end
  resources :evaluations do
    collection do
      post 'no-url/:candidate' => 'evaluations#no_url', as: :no_url
    end
    get 'my' => 'my#index'
  end
  root to: 'evaluations/my#index'
end

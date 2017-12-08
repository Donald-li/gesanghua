Rails.application.routes.draw do
  concern :list do
    collection { get :list }
  end

  root to: 'site/mains#show'

  scope module: :site do
    resources :articles, only: [:index, :show], concerns: :list
    resource :disclosure, only: :show
    get '/p/:alias', to: 'pages#show'
    resource :contribution, only: :show
    resources :pairs, only: [:index, :show]
    resources :reads, only: [:index, :show]
    resources :camps, only: [:index, :show]
    resources :goods, only: [:index, :show]
    resources :certificates, only: [:show]
    resource :feedback, only: [:new, :create]
    resources :book_angles, only: [:index, :show]
  end

  namespace :account do
    resource :modify_password, only: [:edit, :update]
    resource :profile, only: [:show, :edit, :update]
  end
end

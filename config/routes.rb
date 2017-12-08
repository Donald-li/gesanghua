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
    resources :donations, only: [:index]
    resources :raises, only: [:index]
    resources :pairs, only: [:index, :show] do
      resources :mailboxes, only: [:index, :show]
    end
    resources :agents, only: [:index, :new, :edit]
    resources :activities, only: [:index]
  end

  namespace :gsh_plus do
  end
end

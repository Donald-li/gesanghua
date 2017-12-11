Rails.application.routes.draw do
  concern :switch do
    member { put :switch }
  end
  concern :move do
    member { put :move }
  end
  concern :list do
    collection { get :list }
  end
  concern :download do
    member { get :download }
  end
  concern :recommend do
    member { put :recomment }
  end
  concern :excel_output do
    collection { get :excel_output }
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

  namespace :admin do
    get '/login' => 'sessions#new', as: :login
    match '/logout', to: 'sessions#destroy', as: :logout, via: :delete
    resource :session, only: :create
    resource :modify_password, only: [:edit, :update]
    resource :main, only: :show
  end

  mount RuCaptcha::Engine => "/rucaptcha"
end

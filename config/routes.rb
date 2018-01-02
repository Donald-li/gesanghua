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
    member { put :recommend }
  end
  concern :excel_output do
    collection { get :excel_output }
  end

  concern :file_download do
    member { get :file_download }
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
    get '/account/modify-password' => 'modify_password#edit', as: :modify_password
    put '/account/modify-password' => 'modify_password#update', as: :modify_password_update
    resource :main, only: :show
    resources :administrators, concerns: :switch
    resources :audits, only: [:index, :show]
    resources :adverts, concerns: [:move, :switch]
    resources :articles, concerns: [:switch, :recommend]
    resources :article_categories, concerns: [:move, :switch]
    resources :supports, concerns: [:move, :switch]
    resources :pages, concerns: [:move, :switch]
    resources :project_templates
    resources :audit_reports, concerns: [:switch, :file_download]
    resources :financial_reports, concerns: [:switch, :file_download]
    resources :funds, concerns: [:switch, :move]
    resources :fund_categories, concerns: [:switch, :move]
    resources :specials
    resources :pairs, concerns: [:switch]
    resources :pair_applies
    resources :pair_lists, concerns: [:switch]
    resources :support_categories, concerns: [:move, :switch]
    resources :county_users, concerns: [:switch]
  end

  namespace :school do
    resource :main, only: :show
  end

  namespace :api do
    namespace :v1 do
    end
  end

  # 支持
  scope module: :support do
    resources :uploads, path: 'upload', only: [:create, :destroy]
  end

  mount RuCaptcha::Engine => "/rucaptcha"
  mount ChinaCity::Engine => '/china_city'

end

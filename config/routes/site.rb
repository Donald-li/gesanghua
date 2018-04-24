scope module: :site do

  resources :articles, only: [:index, :show]
  resources :specials, only: [:index, :show]
  resources :campaigns, only: [:index, :show]
  resources :disclosures, only: [:index, :show], concerns: [:file_download]
  resources :audit_reports, only: [:index, :show], concerns: [:file_download]
  get '/p/:alias', to: 'pages#show'
  resource :contribution, only: :show
  resources :pairs, only: [:index, :show], concerns: [:detail]
  resources :reads, only: [:index, :show], concerns: [:detail]
  resources :camps, only: [:index, :show], concerns: [:detail]
  resources :goods, only: [:index, :show], concerns: [:detail]
  resources :donate_records, only: :index
  resources :certificates, only: [:show]
  resource :feedback, only: [:new, :create]
  resources :book_angles, only: [:index, :show]
  resources :donates, only: [:new, :create]

  # 支付页
  resource :pay, only: [:new, :show]

end

scope module: :user do
  resources :wechat_connects, only: :new do
    collection do
      get :callback
    end
  end
end

namespace :account do
  get '/login' => 'sessions#new', as: :login
  match '/logout', to: 'sessions#destroy', as: :logout, via: :delete
  resource :session, only: [:create, :edit, :update] do
    member do
      get :forget
      post :find_back
      get :info
      post :find_back_by_email
      post :email_get_code
    end
  end
  resources :orders do
    # 我的捐助
    collection do
      get 'select_tab(/:type)', to: 'orders#select_tab', as: 'select_tab'
    end
  end
  resources :pairs, only: [:index] # 我的结对
  resources :bookshelves, only: [:index] # 我的图书角
  resources :teams, only: [:index] # 我的团队
  resources :offline_users, only: [:index, :update, :create] # 捐助管理
  resource :level, only: [:show] # 我的勋章
  resource :registration, only: [:show, :new, :create]
  resource :modify_password, only: [:edit, :update]
  resource :profile, only: [:show, :edit, :update]
  resources :donations, only: [:index]
  resources :raises, only: [:index]
  resources :pairs, only: [:index, :show] do
    resources :mailboxes, only: [:index, :show]
  end
  resources :agents, only: [:index, :new, :edit]
  resources :activities, only: [:index]
  resources :personals do # 个人信息
    collection do
      post :binding
    end
  end
end

namespace :gsh_plus do
end

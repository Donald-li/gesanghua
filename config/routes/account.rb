namespace :account do
  get '/login' => 'sessions#new', as: :sign_in
  match '/logout', to: 'sessions#destroy', as: :sign_out, via: :delete
  resource :session, only: [:create, :edit, :update] do
    member do
      get :forget
      post :find_back
      get :info
      post :find_back_by_email
      post :email_get_code
    end
  end
  resources :registrations, only: [:new, :create] do
    collection do
      get :bind
    end
  end
  resources :orders, only: [:index] # 我的捐助
  resources :pairs, only: [:index] do     # 我的结对
    resources :children_mailboxs
  end
  resources :bookshelves, only: [:index] # 我的图书角
  resources :teams, only: [:index, :new, :create, :edit, :update] do # 我的团队
    collection do
      get :guide
      post :exit_team
    end
    resources :transfers
    resources :donations
  end
  resources :offline_users # 捐助管理
  resource :level, only: [:show] # 我的勋章
  resources :campaigns
  resource :registration, only: [:show, :new, :create]
  resource :modify_password, only: [:edit, :update]
  resources :donations, only: [:index]
  resources :raises, only: [:index]
  resources :pairs, only: [:index, :show] do
    resources :mailboxes, only: [:index, :show]
  end
  namespace :user_center do
    resource :profile#, only: [:show, :edit, :update]
    resource :account, only: [:show, :edit, :update]
    resource :bind, only: [:show, :edit, :update]
  end
  resources :agents, only: [:index, :new, :edit]
  resources :activities, only: [:index]
end

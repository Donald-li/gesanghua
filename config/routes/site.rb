scope module: :site do

  resources :articles, only: [:index, :show]
  resources :specials, only: [:show]
  resources :campaigns
  resource :disclosure, only: :show
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

end

scope module: :user do
  resources :wechat_connects, only: :new do
    collection do
      get :callback
    end
  end
end

namespace :gsh_plus do
end

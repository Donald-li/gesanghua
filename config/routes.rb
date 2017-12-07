Rails.application.routes.draw do
  concern :list do
    collection { get :list }
  end

  root to: 'site/mains#show'

  scope module: :site do
    resources :articles, only: [:index, :show], concerns: [:list]
  end
end

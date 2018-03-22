
namespace :account do
  resources :registrations, only: [:new, :create] do
    collection do
      get :bind
    end
  end
end

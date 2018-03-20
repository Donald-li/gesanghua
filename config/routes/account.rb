
namespace :account do
  resources :registrations, only: [:new, :create]
end

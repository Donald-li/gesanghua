
namespace :platform do
  root to: 'mains#show'
  namespace :school do
    namespace :apply do
      resources :pairs do
        member do
          resources :children
        end
      end
      resources :reads
      resources :radios
      resources :cares
      resources :movies
      resources :movie_cares
    end
  end
end

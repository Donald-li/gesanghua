
namespace :platform do
  root to: 'mains#show'
  namespace :school do
    resource :profile, only: [:edit, :update]
    resource :teacher_profile, only: [:edit, :update]
    namespace :apply do
      resources :pairs do
        resources :children do
          collection do
            get :child_list
          end
        end
      end
      resources :reads
      resources :radios
      resources :cares
      resources :movies
      resources :movie_cares
      resources :camps
    end
    resources :teachers # 教师管理
    resources :feedbacks # 定期反馈
  end
end

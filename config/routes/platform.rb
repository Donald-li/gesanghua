
namespace :platform do
  root to: 'mains#show'
  namespace :school do
    resource :profile, only: [:edit, :update]
    resource :teacher_profile, only: [:edit, :update]
    namespace :apply do
      resources :pairs do
        resources :children, concerns: :excel_output do
          collection do
            get :child_list
          end
        end
      end
      resources :reads do
        collection do
          get :new_supplement
          post :create_supplement
        end
        member do
          get :edit_supplement
          patch :update_supplement
          get :bookshelves
          get :supplements
        end
      end
      resources :goods_projects
      # resources :cares
      resources :movies
      resources :movie_cares
      resources :camps do
        resources :members do
          collection do
            get :member_list
          end
        end
      end
      resources :receive_feedbacks, only: [:new, :create] #收货反馈
      resources :install_feedbacks, only: [:new, :create] #安装发放反馈
    end
    resources :teachers # 教师管理
    resources :feedbacks # 定期反馈
  end
end

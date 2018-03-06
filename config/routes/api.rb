namespace :api do
  namespace :v1 do
    resource :session, only: :create

    namespace :account do
      resources :donate_records, only: [:index] do
        collection do
          get :projects
        end
        member do
          get :record_details
        end
      end

      resources :pair_children, only: [:index] do
        collection do
          get :feedback_list
        end
      end
    end

    namespace :gsh_plus do
      resources :mains, only: [:index]
      resources :schools, only: [:create]
      resources :project_applies, only: [:new, :show] # 项目申请
      resources :gsh_children, only: [] do
        collection do
          post :match_identity
          get :confirm_identity
          post :confirm
          get :edit_child
          post :update_child
        end
      end
    end

    resource :main, only: [:show] do
      get :contribute
      post :settlement
      post :month_contribute
      get :banners
    end

    resource :wechat do
      collection do
        get :authorize
        post :callback
      end
    end

    resources :projects, only: [] do
      collection do
        get 'description/:name', to: 'projects#description', as: 'description'
      end
    end

    resource :pair, only: [:show]
    resources :children do
      collection do
        get :get_address_list
      end
    end

    resource :read, only: [:show] do
      member do
        get :get_address_list
        get :bookshelves_list
      end
    end
    resources :project_reports, only: :index
    resources :grant_reports, only: :index
    resources :visit_reports, only: :index
    resources :projects, only: :show
    resources :pair_children, only: :show do
      collection do
        post :complaint
        get :contribute
        post :settlement
      end
    end
    resources :children_grants do
      collection do
        get :grants_list
      end
    end
    resources :teams
    resources :donate_records, only: [:index, :show] do
      member do
        get :certificate
      end
    end
    resources :offline_donors, only: [] do
      collection do
        get :donor_list
      end
    end

    resources :cooperation_pairs do
      collection do
        get :verified_students
      end
    end

    resources :cooperation_pair_students do
      member do
        get :edit_reason
        patch :update_reason
      end
      collection do
        get :qrcode
        get :checked_list
        get :get_school
        post :submit_list
        get :child_grants
      end
    end

    resources :home_visits do
      collection do
        get :qrcode
        get :get_child
      end
    end

    resources :school_users do
      collection do
        post :update_school
        get :get_school_teachers
        post :create_teacher
        get :get_projects
        get :get_teacher
        post :update_teacher
        post :delete_teacher
        get :get_school_user
        post :update_school_user
      end
    end

    resources :pair_feedbacks do
      collection do
        post :find_child
        post :create_pair_feedback
      end
    end
    # 微信支付
    resource :wechat_payment, only: [] do
      collection do
        get :pay
        get :h5
      end
    end

    # 支付宝支付
    resource :alipay_payment, only: [] do
      collection do
        get :h5
      end
    end

    # 微信签名
    resource :sign_package, only: [:show]

    namespace :staff do
      resources :grant_batches, only: [:index, :show] do
        resources :grants, only: [:index, :show, :update]
      end
    end

  end

  namespace :common do
    resources :uploads, only: [:create, :destroy]
  end
end

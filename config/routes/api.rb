namespace :api do
  namespace :v1 do
    resource :session, only: :create

    # 账号
    namespace :account do
      resources :donate_records, only: [:index] do
        collection do
          get :projects
          get :account_records
          get :voucher_records
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

      resources :users, only: [:index] do
        collection do
          get :get_user_details
          get :get_user_promoter_record
          post :update_user
          get :has_team
          get :balance
        end
      end

      resources :teams do
        collection do
          get :team_info
          get :member
          get :donate_records
          post :turn_team
          get :dismiss
          post :join_team
          post :exit_team
        end
      end

      resources :campaigns, only: [:index]

      resources :my_reads

      resources :vouchers do
        collection do
          post :apply_voucher
        end
      end
    end

    # 协作平台
    namespace :cooperation do
      resources :badges, only: [:index, :show] # 我的徽章
      resources :tasks, only: [:index, :show] do
        collection do
          get :my_tasks
          post :apply
          get :cancel
          get :workplace
          get :category
          post :finish
        end
      end
    end

    # 格桑花+
    namespace :gsh_plus do
      resources :mains, only: [:index]
      resources :schools, only: [:create, :show]
      resources :project_applies, only: [:new, :show] # 项目申请
      resources :volunteers do
        collection do
          get :majors
          get :volunteer_apply
          get :volunteer_info
          get :edit_volunteer
          post :update_volunteer
          post :vacation
          post :cancel_vacation
          get :duration
        end
      end
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

    resources :bookshelves do
      member do
        post :define_name
        get :class_list
        get :show_logistic
      end
    end

    resources :bookshelf_supplements

    resources :read_supplements do
      collection do
        get :can_apply
      end
      member do
        get :class_list
        get :show_logistic
      end
    end

    resources :read_applies

    resource :main, only: [:show] do
      post :month_contribute
      get :banners
    end

    # 捐助项
    resources :donate_items, only: [:index]

    resource :wechat do
      collection do
        get :authorize
        post :callback
      end
    end

    resources :project_reports, only: :index
    resources :grant_reports, only: :index
    resources :visit_reports, only: :index
    resources :projects, only: :show
    resources :campaigns, only: [:index, :show] do
      member do
        post :apply
        get :success
      end
    end
    resources :pair_children, only: :show do
      collection do
        post :complaint
        get :contribute
        post :settlement
      end
    end

    resources :projects, only: [:index] do
      collection do
        get 'description/:name', to: 'projects#description', as: 'description'
      end
    end

    resources :applies, only: [:index, :show]

    resource :pair, only: [:show]
    resources :children do
      collection do
        get :get_address_list
      end
    end

    resource :read, only: [:show] do
      member do
        get :get_address_list
        get :applies_list
      end
    end

    resource :flower, only: [:show] do
      member do
        get :get_address_list
        get :applies_list
      end
    end

    resource :radio, only: [:show] do
      member do
        get :get_address_list
        get :applies_list
      end
    end

    resources :receive_feedbacks, only: [:create]
    resources :install_feedbacks, only: [:create]

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

    # 收货&安装反馈接口
    resources :feedbacks, only: [:index]

    # 捐助接口
    resource :donate, only: [] do
      collection do
        post :item
        post :apply
        post :gsh
      end
    end

    resources :offline_donors, only: [] do
      collection do
        get :donor_list
        get :get_current_user
        get :get_donor_info
        post :delete_donor
        post :create_donor
        post :update_donor
      end
    end

    resources :cooperation_checks, only: [:index] do
      collection do
        get :identity_user_info
      end
    end

    resources :cooperation_pairs do
      collection do
        get :verified_students
      end
    end

    resources :cooperation_reads, except: [:destroy] do
      collection do
        get :read_donate_item
      end
    end
    resources :cooperation_radios, except: [:destroy] do
      member do
        get :show_logistic
      end
    end
    resources :cooperation_cares, except: [:destroy]
    resources :cooperation_movie_cares, except: [:destroy]
    resources :cooperation_movies, except: [:destroy]

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

    resources :cooperation_regular_feedbacks do
      collection do
        get :feedback_list
        get :qrcode
        get :get_info
      end
    end

    resources :home_visits do
      collection do
        get :qrcode
        get :get_child
      end
    end

    resources :family_members

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

      resources :staffs, only: [:index] do
        collection do
          get :volunteer_list
        end
      end
    end
    namespace :common do
      resources :sms_codes, only: :create
    end
  end

  namespace :common do
    resources :uploads, only: [:create, :destroy]
  end
end

Rails.application.routes.draw do
  concern :switch do
    member { put :switch }
  end
  concern :move do
    member { put :move }
  end
  concern :list do
    collection { get :list }
  end
  concern :download do
    member { get :download }
  end
  concern :recommend do
    member { put :recommend }
  end
  concern :excel_output do
    collection { get :excel_output }
  end
  concern :excel_upload do
    collection { get :excel_upload}
  end
  concern :excel_import do
    collection { put :excel_import}
  end
  concern :share do
    member { get :share }
  end
  concern :file_download do
    member { get :file_download }
  end

  concern :qrcode_download do
    member { get :qrcode_download }
  end

  concern :remarks do
    member { get :remarks }
  end

  concern :cancel do
    member { get :cancel }
  end

  concern :info do
    collection { get :info }
  end

  root to: 'site/mains#show'

  scope module: :site do
    resources :articles, only: [:index, :show], concerns: :list
    resource :disclosure, only: :show
    get '/p/:alias', to: 'pages#show'
    resource :contribution, only: :show
    resources :pairs, only: [:index, :show]
    resources :reads, only: [:index, :show]
    resources :camps, only: [:index, :show]
    resources :goods, only: [:index, :show]
    resources :certificates, only: [:show]
    resource :feedback, only: [:new, :create]
    resources :book_angles, only: [:index, :show]

    # 微信支付通知接口
    post "notify" => "orders#notify"
  end

  scope module: :user do
    resources :wechat_connects, only: :new do
      collection do
        get :callback
      end
    end
  end

  namespace :account do
    resource :modify_password, only: [:edit, :update]
    resource :profile, only: [:show, :edit, :update]
    resources :donations, only: [:index]
    resources :raises, only: [:index]
    resources :pairs, only: [:index, :show] do
      resources :mailboxes, only: [:index, :show]
    end
    resources :agents, only: [:index, :new, :edit]
    resources :activities, only: [:index]
  end

  namespace :gsh_plus do
  end

  namespace :admin do
    get '/login' => 'sessions#new', as: :login
    match '/logout', to: 'sessions#destroy', as: :logout, via: :delete
    resource :session, only: :create
    get '/account/modify-password' => 'modify_password#edit', as: :modify_password
    put '/account/modify-password' => 'modify_password#update', as: :modify_password_update
    # get '/selects/gsh_child_user' => 'selects#gsh_child_user'
    # get '/selects/teacher_user' => 'selects#teacher_user'
    # get '/selects/teacher_school' => 'selects#teacher_school'

    resource :main, only: :show
    resources :users, concerns: :switch do
      member do
        get :invoices
        post :bill
      end
      resources :donate_records, only: [:index, :destroy]
    end
    resources :administrators, concerns: :switch
    resources :audits, only: [:index, :show]
    resources :adverts, concerns: [:move, :switch]
    resources :articles, concerns: [:switch, :recommend]
    resources :article_categories, concerns: [:move, :switch]
    resources :supports, concerns: [:move, :switch]
    resources :pages, concerns: [:move, :switch]
    resources :projects
    resources :school_applies do
      member do
        patch :update_audit
      end
      collection do
        post :create_audit
      end
    end
    resources :audit_reports, concerns: [:switch, :file_download]
    resources :financial_reports, concerns: [:switch, :file_download]
    resources :funds, concerns: [:switch, :move] do
      resource :fund_adjust_amount, only: [:new, :create]
    end
    resources :fund_categories, concerns: [:switch, :move]
    resources :specials, concerns: [:switch] do
      resources :special_adverts
      resources :special_articles
    end

    resources :project_book_seasons
    resources :read_applies do
      member do
        get :audit
        get :students
      end
      collection do
        post :create_audit
      end
    end
    resources :project_camp_seasons
    resources :project_radio_seasons
    resources :project_flower_seasons

    resources :pair_grant_exceptions
    resources :pair_reports, concerns: [:switch]
    resources :pair_seasons, concerns: [:switch]
    resources :pair_donate_records, only: [:index, :show]
    resources :pair_applies do
      resources :pair_students, concerns: [:remarks] do
        member do
          patch :update_audit
        end
        collection do
          post :create_audit
        end
      end
    end
    resources :pair_student_lists, concerns: [:switch, :remarks, :share, :qrcode_download] do
      resources :student_grants
      member do
        put :turn_over
      end
    end
    resources :pair_grants, concerns: [:excel_output] do
      member do
        get :edit_delay
        get :edit_cancel
        get :new_feedback
        get :edit_feedback
        patch :update_delay
        patch :update_cancel
        patch :update_feedback
      end
      collection do
        post :create_feedback
      end
    end

    resources :flower_projects do
      resources :flower_donate_records
      resources :flower_feedbacks
    end
    resources :flower_applies do
      resources :flower_approve_logs
      member do
        patch :update_audit
        put :switch_to_raise
      end
      collection do
        post :create_audit
      end
    end

    resources :remarks
    resources :support_categories, concerns: [:move, :switch]
    resources :county_users, concerns: [:switch]
    resources :income_sources, concerns: :move
    resources :volunteer_applies, only: [:index, :edit, :update]
    resources :volunteers, concerns: [:switch] do
      resources :task_volunteers
      resources :service_histories, only: [:index, :show]
      member do
        put :switch_job
      end
    end
    resources :tasks, concerns: [:switch] do
      resources :task_applies, only: [:index, :edit, :update]
    end
    resources :task_achievements
    resources :appoint_tasks do
      member do
        get :switch_edit
        put :switch_update
        get :check_edit
        put :check_update
      end
    end
    resources :gsh_children do
      resources :apply_records, only: [:index, :show]
    end
    resources :schools, concerns: [:excel_output] do
      resources :school_teachers
      resources :school_project_applies
    end
    resources :teachers
    resources :campaign_categories
    resources :campaigns, concerns: [:switch] do
      resources :campaign_enlists, concerns: [:excel_output] do
        member do
          put :cancel
          get :calculate_total_price
        end
      end
    end
    resources :income_records, concerns: [:excel_upload, :excel_import] do
      collection do
        get :template_download
      end
    end
    resources :expenditure_records, concerns: [:excel_upload, :excel_import] do
      collection do
        get :template_download
      end
    end
    resources :expenditure_uploads, only: [:new, :create]
    resource :data_statistic, only: [:show]
    resource :donate_statistic, only: [:show], concerns: [:excel_output]
    resources :vouchers, concerns: :switch
    resources :month_donates do
      resources :month_donate_records
    end

    resources :complaints
    resources :radio_applies do
      member do
        patch :check
      end
    end
    resources :beneficial_children, concerns: [:excel_upload, :excel_import]

    resources :radio_projects, concerns: :switch do
      member do
        put :shipment
      end
      resources :radio_donate_records
    end
  end

  namespace :school do
    resource :main, only: :show
  end

  namespace :api do
    namespace :v1 do
      resource :main, only: [:show] do
        post :contribute
        get :banners
      end

      resource :wechat do
        collection do
          get :authorize
          post :callback
        end
      end
      resource :pair, only: [:show]
      resources :children do
        collection do
          get :get_address_list
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
      resources :donate_records
      resources :offline_donors, only: [] do
        collection do
          get :donor_list
        end
      end

    end

    namespace :common do
      resources :uploads, only: [:create, :destroy]
    end
  end

  # 支持
  scope module: :support do
    resources :uploads, path: 'upload', only: [:create, :destroy]
    resources :selects, only: [] do
      collection do
        get :schools
        get :users
        get :gsh_child_user
        get :teacher_user
        get :school_user
        get :volunteers
        get :campaign_enlist_user
        get :seasons
        get :flower_seasons
      end
    end
    resources :ajaxes, only: [] do
      collection do
        get :school_users
        get :user_statistics
        get :income_statistics
        get :bill_amount
      end
    end
  end

  mount RuCaptcha::Engine => "/rucaptcha"
  mount ChinaCity::Engine => '/china_city'

end

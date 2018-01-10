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
    get '/selects/gsh_child_user' => 'selects#gsh_child_user'
    get '/selects/teacher_user' => 'selects#teacher_user'
    get '/selects/teacher_school' => 'selects#teacher_school'

    resource :main, only: :show
    resources :users, concerns: :switch do
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
    resources :project_camp_seasons
    resources :project_radio_seasons
    resources :project_flower_seasons

    resources :pair_seasons, concerns: [:switch]
    resources :pair_periods, concerns: [:switch, :move]
    resources :pair_applies do
      resources :pair_students, concerns: [:remarks] do
        member do
          get :new_audit
        end
        collection do
          post :create_audit
        end
      end
    end
    resources :pair_student_lists, concerns: [:switch, :remarks, :share, :qrcode_download] do
      member do
        put :turn_over
      end
    end
    resources :remarks
    resources :support_categories, concerns: [:move, :switch]
    resources :county_users, concerns: [:switch]
    resources :income_sources, concerns: :move
    resources :volunteer_applies, only: [:index, :edit, :update]
    resources :volunteers, concerns: [:switch] do
      resources :service_histories, only: [:index, :show]
      member do
        put :switch_job
      end
    end
    resources :tasks, concerns: [:switch] do
      resources :task_applies, only: [:index, :edit, :update]
    end
    resources :gsh_children do
      resources :apply_records, only: [:index, :show]
    end
    resources :schools do
      member do
        get :contact_show
        get :contact_edit
        put :contact_update
      end
      resources :teachers
      resources :contacts
    end
  end

  namespace :school do
    resource :main, only: :show
  end

  namespace :api do
    namespace :v1 do
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
      end
    end
  end

  mount RuCaptcha::Engine => "/rucaptcha"
  mount ChinaCity::Engine => '/china_city'

end


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
      get :combine
      post :set_combine
      get :manager
      post :set_manager
    end
    collection do
      get :batch_manage
      put :send_message
    end
    resources :donate_records, only: [:index, :destroy] do
      member do
        post :refund # 退款
      end
    end
    resources :account_records
  end
  resources :administrators, concerns: :switch
  resources :protocols, concerns: :switch
  resources :administrator_logs, only: [:index]
  resources :operate_logs, only: :index
  resources :audits, only: [:index, :show]
  resources :adverts, concerns: [:move, :switch]
  resources :articles, concerns: [:switch, :recommend]
  resources :article_categories, concerns: [:move, :switch]
  resources :announcements, concerns: [:switch]
  resources :badge_levels, concerns: [:move]
  resources :supports, concerns: [:move, :switch]
  resources :pages, concerns: [:move, :switch]
  resources :projects, concerns: [:move]
  resources :donate_items, concerns: [:move, :switch] do
    resources :donate_item_amount_tabs, concerns: [:switch]
  end
  resources :partners, concerns: [:move, :switch]
  resources :school_applies, concerns: :check
  resources :audit_reports, concerns: [:switch, :file_download]
  resources :financial_reports, concerns: [:switch, :file_download]
  resources :bank_reports, concerns: [:switch, :file_download]
  resources :funds, concerns: [:switch, :move] do
    resource :fund_adjust_amount, only: [:new, :create, :show]
  end
  resources :fund_categories, concerns: [:switch, :move] do
    collection do
      get :statistic
    end
  end
  resources :specials, concerns: [:switch] do
    resources :special_adverts
    resources :special_articles
  end

  resource :team_statistic, only: [:show]
  resources :teams do
    member do
      put :dismiss
      get :donate_records
    end
    resources :team_members
  end

  resources :project_book_seasons, concerns: [:switch]
  resources :read_applies, concerns: :check do
    member do
      get :audit
      get :students
      get :switch
    end
    collection do
      get :supply_new
      post :create_audit
      post :supply_create
    end
  end
  resources :read_projects, concerns: :switch do
    member do
      get :supply_edit
      put :finish_project
    end
    # resources :read_donate_records
    resources :bookshelf_donate_records
    resources :supplement_donate_records
    resources :read_exception_records
    resources :bookshelves, concerns: :switch do
      member do
        get :accrue
        get :shipment
        post :create_shipment
        get :bookshelf_receive
        get :bookshelf_install
      end
    end
    resources :supplements, concerns: :switch do
      member do
        get :shipment
        post :create_shipment
        get :supplement_receive
        get :supplement_install
      end
    end
  end
  resources :management_fee_months, only: [:index, :update]
  resources :management_fees, only: [:index, :show, :create]
  resources :read_reports, concerns: [:switch]
  resources :read_continual_feedbacks, concerns: [:recommend]
  resources :project_movie_seasons, concerns: [:switch]
  resources :project_movie_care_seasons, concerns: [:switch]

  resources :pair_grant_exceptions
  resources :pair_reports, concerns: [:switch]
  resources :pair_seasons, concerns: [:switch]
  resources :pair_donate_records, only: [:index, :show]
  resources :pair_applies do
    resources :pair_students, concerns: [:check, :excel_upload, :excel_import] do
      member do
        patch :update_audit
      end
      collection do
        post :create_audit
      end
    end
    resources :pair_exception_records
  end
  resources :pair_continual_feedbacks, concerns: [:recommend]
  resources :pair_thank_notes do
    collection do
      get :qrcode_download
    end
  end
  resources :home_visits, only: [:index, :show]
  resources :pair_student_lists, concerns: [:switch, :share, :qrcode_download] do
    member do
      get :appoint
      post :appoint_donor
    end
    collection do
      get :batch_manage
      post :grade_add_one
      post :grade_minus_one
      post :push_notice
      post :update_priority
    end
    resources :student_grants do
      collection do
        get :match
        post :match_donate
      end
      member do
        post :close
      end
    end
    member do
      put :turn_over
    end
  end
  resources :pair_grant_batches, concerns: [:excel_output] do
    resources :items, controller: :pair_grant_batch_items, only: [:index, :create, :destroy]
  end

  resources :pair_grants, concerns: [:excel_output, :switch] do
    member do
      get :accrue
      get :edit_delay
      put :cancel_delay
      get :edit_cancel
      get :new_feedback
      get :edit_feedback
      patch :update_delay
      patch :update_cancel
      patch :update_feedback
      get :share
      get :qrcode_download
    end
    collection do
      post :create_feedback
    end
  end


  resources :camps do
    resources :camp_users
  end

  resources :camp_applies, concerns: [:switch, :check]
  resources :camp_projects, concerns: [:switch] do
    member do
      get :accrue
      put :change_state
      get :camp_member
    end
    resources :project_season_apply_camps, concerns: [:switch] do
      member do
        get :camp_member
        put :change_state
      end
    end
    resources :camp_donate_records
    resources :camp_exception_records
    resources :camp_execute_feedbacks, concerns: :recommend
  end

  resources :camp_continual_feedbacks, concerns: [:recommend]
  resources :camp_project_reports, concerns: [:switch]

  resources :project_season_apply_camp_students, concerns: [:check, :excel_upload, :excel_import]
  resources :project_season_apply_camp_teachers, concerns: [:check, :excel_upload, :excel_import]

  resources :camp_document_estimates # 拓展营概算
  resources :camp_document_budges # 拓展营预算
  resources :camp_document_finances # 拓展营决算
  resources :camp_document_volunteers, concerns: [:excel_upload, :excel_import] # 拓展营志愿者
  resources :camp_document_summaries # 拓展营总结

  resources :camp_project_resources # 拓展营资源

  resources :remarks
  resources :support_categories, concerns: [:move, :switch]
  resources :county_users, concerns: [:switch]
  resources :income_sources, concerns: :move do
    collection do
      get :statistic
    end
    resource :source_adjust_amount, only: [:new, :create, :show]
  end
  resources :volunteer_applies, only: [:index, :edit, :update]
  resources :volunteers, concerns: [:switch] do
    resources :task_volunteers
    resources :service_histories, only: [:index, :show]
    member do
      put :switch_job
    end
  end
  resources :majors
  resources :tasks, concerns: [:switch] do
    collection do
      get :batch_manage
      put :send_message
    end
    resources :task_applies, only: [:index, :edit, :update]
  end
  resources :task_categories
  resources :workplaces, concerns: [:switch]
  resources :task_achievements, concerns: [:switch] do
    member do
      get :switch_edit
      put :switch_update
    end
  end
  resources :appoint_tasks
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
    member do
      put :switch_state
    end
    resources :campaign_enlists, concerns: [:excel_output] do
      member do
        put :cancel
        get :calculate_total_price
      end
    end
  end
  resources :income_records, concerns: [:excel_upload, :excel_import, :template_download] do
    member do
      get :return_back
    end
  end

  resources :expenditure_ledgers, concerns: [:move]
  resources :expenditure_records, concerns: [:excel_upload, :excel_import, :template_download]
  resources :expenditure_uploads, only: [:new, :create]
  resource :data_statistic, only: [:show]
  resource :donate_statistic, only: [:show], concerns: [:excel_output]
  resource :finance_statistic, only: [:show]
  resources :vouchers, concerns: :switch
  resources :month_donates do
    resources :month_donate_records
  end

  resources :complaints
  resources :beneficial_children, concerns: [:excel_upload, :excel_import]

  resources :project_goods_seasons, concerns: [:switch]
  resources :goods_applies, concerns: :check do
    resources :goods_approve_logs
    member do
      get :audit
      patch :update_audit
      put :switch_to_raise
    end
    collection do
      post :create_audit
    end
  end
  resources :goods_projects, concerns: [:switch] do
    member do
      get :accrue
      get :shipment
      post :create_shipment
      put :receive
      put :done
      put :cancelled
      put :refunded
    end
    resource :goods_receive
    resource :goods_install, concerns: [:recommend]
    resources :goods_donate_records
    resources :goods_exception_records
  end
  resources :goods_reports ,concerns: [:switch]
  resources :goods_continual_feedbacks ,concerns: [:recommend]

  resources :project_radio_seasons, concerns: [:switch]
  resources :radio_applies, concerns: :check
  resources :radio_projects, concerns: :switch do
    member do
      get :shipment
      post :create_shipment
    end
    resources :radio_donate_records
    resources :radio_feedbacks, concerns: [:recommend]
  end
  resources :radio_continual_feedbacks, concerns: [:recommend]

  resources :movie_continual_feedbacks, concerns: [:recommend]
  resources :movie_applies, concerns: :check do
    resources :movie_exception_records
  end
  resources :movie_schools do
    resources :movie_feedbacks, concerns: [:recommend]
  end

  resources :movie_care_continual_feedbacks, concerns: [:recommend]
  resources :movie_care_applies, concerns: :check do
    resources :movie_care_exception_records
  end
  resources :movie_care_schools do
    resources :movie_care_feedbacks, concerns: [:recommend]
  end

end

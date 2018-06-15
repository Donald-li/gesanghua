namespace :camp do

  get '/login' => 'sessions#new', as: :login
  match '/logout', to: 'sessions#destroy', as: :logout, via: :delete
  resource :session, only: :create
  get '/account/modify-password' => 'modify_password#edit', as: :modify_password
  put '/account/modify-password' => 'modify_password#update', as: :modify_password_update
  resource :main, only: :show
  resources :users

  resources :applies, concerns: [:switch]
  resources :projects, concerns: [:switch] do
    member do
      put :change_state
      get :camp_member
    end
    resources :project_season_apply_camps, concerns: [:switch] do
      member do
        get :camp_member
      end
    end
    resources :donate_records
    resources :execute_feedbacks, concerns: :recommend
  end

  resources :project_reports, concerns: [:switch]

  resources :project_season_apply_camp_students, concerns: [:check]
  resources :project_season_apply_camp_teachers, concerns: [:check]

  resources :camp_document_estimates # 拓展营概算
  resources :camp_document_budges # 拓展营预算
  resources :camp_document_finances # 拓展营决算
  resources :camp_document_volunteers, concerns: [:excel_upload, :excel_import] # 拓展营志愿者
  resources :camp_document_summaries # 拓展营总结

  resources :camp_project_resources # 拓展营资源

end

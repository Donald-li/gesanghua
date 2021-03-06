
  # 支持
scope module: :support do
  resources :uploads, path: 'upload', only: [:create, :destroy]
  resources :selects, only: [] do
    collection do
      get :schools
      get :bookshelf_schools
      get :school_bookshelves
      get :users
      get :income_records
      get :users_balance
      get :gsh_child_user
      get :teacher_user
      get :school_user
      get :volunteers
      get :campaign_enlist_user
      get :seasons
      get :flower_seasons
      get :applies
      get :majors
      get :camps
      get :camp_users
      get :child_grants
      get :team_manager
      get :county_user
      get :volunteer_user
      get :all_users
      get :wechat_users
      get :funds
      get :grant_children
    end
  end
  resources :ajaxes, only: [] do
    collection do
      get :school_users
      get :user_statistics
      get :income_statistics
      get :bill_amount
      post :submit_pair_children
      post :submit_child_reason
      post :submit_member_reason
      post :submit_camp_members
      post :create_read_bookshelf
      get :edit_read_bookshelf
      post :update_read_bookshelf
      post :delete_read_bookshelf
      get :new_read_supplement
      post :create_read_supplement
      get :edit_read_supplement
      post :update_read_supplement
      post :delete_read_supplement
      post :dismiss_team
      post :turn_team
      get :get_child_priority
      post :set_shelf_name
      post :add_all_grants
      get :batch_accrue
      get :search_wechat_user
    end
  end
end

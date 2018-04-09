
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
      get :camp_funds
      get :camps
      get :camp_users
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


  namespace :api do
    namespace :v1 do
      namespace :account do
        resources :donate_records, only: [:index] do
          collection do
            get :projects
          end
          member do
            get :record_details
          end
        end

        resources :pair_children, only: [:index]
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
      resources :donate_records, only: [:index] do
        member do
          get :certificate
        end
      end
      resources :offline_donors, only: [] do
        collection do
          get :donor_list
        end
      end

      resources :cooperation_pairs

    end

    namespace :common do
      resources :uploads, only: [:create, :destroy]
    end
  end

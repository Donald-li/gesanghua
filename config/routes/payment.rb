# 支付
namespace :payment do
  # 微信支付
  resources :wechat_payments, only: [] do
    collection do
      post :notify
      get :success
      get :failure
    end
  end
end

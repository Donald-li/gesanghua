# 支付
namespace :payment do
  # 微信
  resources :wechat_payments, only: [] do
    collection do
      post :notify
      get :success
      get :failure
    end
  end

  # 支付宝
  resources :alipay_payments, only: [] do
    collection do
      post :notify
      get :success
      get :failure
    end
  end
end

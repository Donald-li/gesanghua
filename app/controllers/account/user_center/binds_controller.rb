class Account::UserCenter::BindsController < Account::BaseController
  layout 'account_user_center'

  # 解绑
  def destroy
    if current_user.bind_wechat?
      current_user.update(openid: nil)
      flash[:notice] = '已解绑'
    else
      flash[:alert] = '没有绑定微信或不能解绑'
    end
  end
end

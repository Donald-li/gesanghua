class Account::UserCenter::BindsController < Account::BaseController
  layout 'account_user_center'

  def edit
  end

  # 绑定
  def callback
    userinfo = get_userinfo
    unionid = userinfo.result['unionid']
    if current_user.openid.present?
      flash[:alert] = '绑定失败，您已绑定微信'
      redirect_to edit_account_user_center_bind_path and return
    end

    if User.where(openid: unionid).exists?
      # flash[:alert] = '该微信已经绑定其他账号'
      # redirect_to edit_account_user_center_bind_path and return
      user = User.find_by(openid: unionid)
      User.combine_user(current_user.phone, user)
      set_current_user(user)
      flash[:notice] = '绑定成功并与其他用户合并，请重新扫码登录'
      callback_url = callback_wechats_url(host: Settings.app_host, port: 80)
      @wechat_url = $wechat_open_client.qrcode_authorize_url(callback_url, "snsapi_login", "wechat")
      reset_session
      redirect_to @wechat_url and return
    end
    current_user.attributes = { openid: unionid, gender: userinfo.result["sex"] }
    # 如果已经存在，不能更新，微信端支付使用的是openid
    current_user.profile = current_user.profile.presence || userinfo.result
    # current_user.name ||= userinfo.result['nickname']
    current_user.nickname ||= userinfo.result['nickname']
    current_user.save
    flash[:notice] = '绑定成功'
    redirect_to edit_account_user_center_bind_path
  end

  # TODO:提示已有用户是否绑定
  # def do_combine_user(openid)
  #   user = User.find_by(openid: unionid)
  #   User.combine_user(current_user.phone, user)
  #   set_current_user(user)
  #   flash[:notice] = '绑定成功'
  #   redirect_to edit_account_user_center_bind_path
  # end

  # 解绑
  def destroy
    if current_user.bind_wechat?
      current_user.update(openid: nil)
      flash[:notice] = '已解绑'
    else
      flash[:alert] = '没有绑定微信或不能解绑'
    end
    redirect_to edit_account_user_center_bind_path
  end

  private
  def get_userinfo
    result = $wechat_open_client.get_oauth_access_token(params["code"]).result
    logger.info result.inspect
    openid = result["openid"]
    access_token = result["access_token"]
    $wechat_open_client.get_oauth_userinfo(openid, access_token, lang="zh_CN")
  end
end

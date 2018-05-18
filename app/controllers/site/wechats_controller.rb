# -*- encoding : utf-8 -*-
class Site::WechatsController < Site::BaseController
  # skip_before_action :login?
  skip_before_action :verify_authenticity_token

  # #登录
  # def new
  #   target_url = params["target_url"]
  #   scope = "snsapi_userinfo"
  #   state = "weixin"
  #   redirect_uri = callback_wechat_connects_url(host: Settings.app_host, port: 80, target_url: target_url)
  #   redirect_to $wechat_open_client.authorize_url(redirect_uri, scope=scope, state=state)
  # end

  #回调
  def callback
    return_url = session.delete(:return_path).presence || root_url

    userinfo = get_userinfo
    logger.info userinfo.inspect
    unionid = userinfo.result['unionid']
    if unionid.blank?
      flash[:alert] = '登录失败'
      redirect_to root_url and return
    end
    user = User.where(openid: unionid).first || User.new
    user.attributes = { openid: unionid, gender: userinfo.result["sex"] }
    # 如果已经存在，不能更新，微信端支付使用的是openid
    user.profile = user.profile.presence || userinfo.result
    # user.name ||= userinfo.result['nickname']
    user.nickname ||= userinfo.result['nickname']
    if user.disable?
      flash[:alert] = '登录失败'
      redirect_to return_url and return
    elsif user.save
      set_current_user(user)
      if user.phone.present?
        redirect_to return_url and return
      else
        redirect_to edit_phone_account_user_center_account_path and return
      end
    else
      flash[:alert] = '登录失败'
      redirect_to return_url and return
    end
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
